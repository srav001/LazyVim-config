local function resolve_tsgo(root)
	local local_bin = root and vim.fs.joinpath(root, "node_modules", ".bin", "tsgo") or nil
	return local_bin and vim.fn.executable(local_bin) == 1 and local_bin or nil
end

-- This for projects I have which use npm workspaces, and tsgo is installed in the root
local function find_tsgo_root(bufnr)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		fname = vim.uv.cwd() or ""
	end
	if fname == "" then
		return nil
	end

	local start = vim.fn.isdirectory(fname) == 1 and fname or vim.fs.dirname(fname)
	local match = vim.fs.find("node_modules/.bin/tsgo", {
		path = start,
		upward = true,
		stop = vim.env.HOME,
		type = "file",
	})[1]

	return match and vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(match))) or nil
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
				-- Populate all default client capabilities (plus our global overrides) so the
				-- server gets full feature negotiation (inlay hints, semantic tokens, etc).
				capabilities = (function()
					local caps = vim.lsp.protocol.make_client_capabilities()
					caps = vim.tbl_deep_extend("force", caps, (opts.servers["*"] or {}).capabilities or {})
					return caps
				end)(),
				-- Match LazyVim's default vtsls UX (inlay hints, imports-on-move, etc).
				settings = (function()
					local typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = { completeFunctionCalls = true },
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					}

					return {
						typescript = typescript,
						-- Keep JS behavior consistent with TS (same as LazyVim's vtsls setup).
						javascript = vim.tbl_deep_extend("force", {}, typescript),
					}
				end)(),
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
					if root then
						on_dir(root)
					end
				end,
			}, opts.servers.tsgo or {})

			-- Let LazyVim manage vtsls; we only gate activation when tsgo is present.
			opts.setup = opts.setup or {}
			local existing_setup = opts.setup.vtsls
			opts.setup.vtsls = function(server, server_opts)
				-- If tsgo is available for this buffer, skip vtsls entirely.
				if find_tsgo_root(0) then
					return true
				end
				-- Otherwise, defer to any existing setup handler (if present).
				if existing_setup then
					return existing_setup(server, server_opts)
				end
				return false
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
