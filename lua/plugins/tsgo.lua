local function resolve_tsgo(root)
	local local_bin = root and vim.fs.joinpath(root, "node_modules", ".bin", "tsgo") or nil

	if local_bin and vim.fn.executable(local_bin) == 1 then
		return local_bin
	end

	return nil
end

-- local function log(msg)
-- 	if vim.g.tsgo_lsp_debug or vim.env.TSGO_LSP_DEBUG then
-- 		vim.notify("[tsgo] " .. msg)
-- 	end
-- end

local function call_root_dir(root_dir_fn, bufnr, on_dir)
	local called = false
	local function on_dir_wrapped(dir)
		called = true
		on_dir(dir)
	end

	local ok, result = pcall(root_dir_fn, bufnr, on_dir_wrapped)
	if ok then
		if not called and type(result) == "string" and result ~= "" then
			on_dir(result)
		end
		return
	end

	-- Back-compat: some configs still use the older `root_dir(fname)` signature.
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local ok2, result2 = pcall(root_dir_fn, fname)
	if ok2 and type(result2) == "string" and result2 ~= "" then
		on_dir(result2)
		return
	end

	-- log("root_dir error: " .. tostring(result))
end

local function find_tsgo_root(fname_or_bufnr, bufnr)
	if type(fname_or_bufnr) == "number" then
		bufnr = fname_or_bufnr
		fname_or_bufnr = vim.api.nvim_buf_get_name(bufnr)
	end

	local fname = fname_or_bufnr
	if (not fname or fname == "") and bufnr and bufnr > 0 then
		fname = vim.api.nvim_buf_get_name(bufnr)
	end
	if not fname or fname == "" then
		fname = vim.uv.cwd() or ""
	end
	if fname == "" then
		-- log("find_tsgo_root: empty fname")
		return nil
	end

	local path = vim.fs.normalize(fname)
	if vim.fn.isdirectory(path) == 0 then
		path = vim.fs.dirname(path)
	end

	if resolve_tsgo(path) then
		-- log("find_tsgo_root: found at " .. path)
		return path
	end
	for parent in vim.fs.parents(path) do
		if resolve_tsgo(parent) then
			-- log("find_tsgo_root: found at " .. parent)
			return parent
		end
	end
	-- log("find_tsgo_root: not found for " .. path)
	return nil
end

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}

			-- Prefer UTF-16 so all attached clients agree on position encoding
			-- (fixes :LspInfo "Position Encodings" warning when mixing tsgo + tailwind, etc).
			opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
				capabilities = {
					general = {
						positionEncodings = { "utf-16" },
					},
					workspace = {
						didChangeConfiguration = {
							dynamicRegistration = true,
						},
					},
				},
			})

			-- tsgo (TypeScript Native Preview) - only starts when the binary is present
			opts.servers.tsgo = vim.tbl_deep_extend("force", {
				mason = false,
				enabled = true,
				-- Use a function so validation doesn't require a globally-executable `tsgo`.
				cmd = function(dispatchers, config)
					local root_dir = config.root_dir
					local tsgo_bin = resolve_tsgo(root_dir)
					if not tsgo_bin then
						error("[tsgo] no project-local tsgo found for root_dir=" .. tostring(root_dir))
					end
					return vim.lsp.rpc.start({ tsgo_bin, "--lsp", "--stdio" }, dispatchers, { cwd = root_dir })
				end,
				filetypes = {
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"javascript",
					"javascriptreact",
					"javascript.jsx",
				},
				single_file_support = false,
				-- `root_dir` must call `on_dir()` (see `:h lsp-root_dir()`).
				root_dir = function(bufnr, on_dir)
					local root = find_tsgo_root(bufnr)
					-- log("root_dir -> " .. tostring(root))
					if root then
						on_dir(root)
					end
				end,
			}, opts.servers.tsgo or {})

			-- vtsls fallback: disabled when tsgo is available for the project
			do
				local existing = opts.servers.vtsls or {}
				local existing_root_dir = existing.root_dir

				local fallback_root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, {
						"tsconfig.json",
						"tsconfig.base.json",
						"jsconfig.json",
						"package.json",
						".git",
					})
					if root then
						on_dir(root)
					end
				end

				local base_root_dir = type(existing_root_dir) == "function" and existing_root_dir or fallback_root_dir

				opts.servers.vtsls = vim.tbl_deep_extend("force", existing, {
					root_dir = function(bufnr, on_dir)
						-- If tsgo is available for this tree, skip vtsls by NOT calling on_dir().
						if find_tsgo_root(bufnr) then
							-- log("vtsls: skipped (tsgo found)")
							return
						end
						return call_root_dir(base_root_dir, bufnr, on_dir)
					end,
				})
			end
		end,
	},

	-- Ensure the fallback server is installed via Mason
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			if not vim.tbl_contains(opts.ensure_installed, "vtsls") then
				table.insert(opts.ensure_installed, "vtsls")
			end
		end,
	},
}
