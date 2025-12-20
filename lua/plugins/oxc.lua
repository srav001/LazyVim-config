local function resolve_oxc_language_server(root)
	local local_bin = root and vim.fs.joinpath(root, "node_modules", ".bin", "oxc_language_server") or nil
	return local_bin and vim.fn.executable(local_bin) == 1 and local_bin or nil
end

-- Find project root that has oxc_language_server installed
local function find_oxc_root(bufnr)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		fname = vim.uv.cwd() or ""
	end
	if fname == "" then
		return nil
	end

	local start = vim.fn.isdirectory(fname) == 1 and fname or vim.fs.dirname(fname)
	local match = vim.fs.find("node_modules/.bin/oxc_language_server", {
		path = start,
		upward = true,
		stop = vim.env.HOME,
		type = "file",
	})[1]

	return match and vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(match))) or nil
end

-- Check if tsgolint is available for type-aware linting
local function has_tsgolint(root)
	if not root then
		return false
	end
	local tsgolint_bin = vim.fs.joinpath(root, "node_modules", ".bin", "tsgolint")
	return vim.fn.executable(tsgolint_bin) == 1
end

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.servers.oxc = vim.tbl_deep_extend("force", {
				mason = false,
				enabled = true,
				capabilities = (function()
					local caps = vim.lsp.protocol.make_client_capabilities()
					caps.general = caps.general or {}
					caps.general.positionEncodings = { "utf-16" }
					return caps
				end)(),
				settings = (function()
					-- Check current buffer for tsgolint availability
					local root = find_oxc_root(0)
					local type_aware = has_tsgolint(root)
					local oxc_settings = {
						run = "onType",
						typeAware = type_aware,
						fixKind = "safe_fix",
					}
					return {
						-- Provide under both section names for compatibility
						oxc = oxc_settings,
						oxc_language_server = oxc_settings,
					}
				end)(),
				cmd = function(dispatchers, config)
					local root_dir = config.root_dir
					local oxc_bin = resolve_oxc_language_server(root_dir)
					if not oxc_bin then
						error("[oxc] no project-local oxc_language_server found for root_dir=" .. tostring(root_dir))
					end
					return vim.lsp.rpc.start({ oxc_bin }, dispatchers, { cwd = root_dir })
				end,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				single_file_support = false,
				root_dir = function(bufnr, on_dir)
					local root = find_oxc_root(bufnr)
					if root then
						on_dir(root)
					end
				end,
			}, opts.servers.oxc or {})
		end,
	},
}
