local function find_root(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" then
		return nil
	end
	-- Look for tsgo binary
	local bin = vim.fs.find("node_modules/.bin/tsgo", {
		path = vim.fs.dirname(file),
		upward = true,
		stop = vim.env.HOME,
	})[1]
	if not bin then
		return nil
	end
	local root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(bin)))
	-- Use tsgo if @typescript/native-preview is installed
	if vim.uv.fs_stat(root .. "/node_modules/@typescript/native-preview") then
		return root
	end
	return nil
end

local ts_settings = {
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
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			local caps = vim.lsp.protocol.make_client_capabilities()
			caps.general = caps.general or {}
			caps.general.positionEncodings = { "utf-16" }

			opts.servers.tsgo = {
				mason = false,
				capabilities = caps,
				settings = { typescript = ts_settings, javascript = ts_settings },
				cmd = function(dispatchers, config)
					local bin = config.root_dir .. "/node_modules/.bin/tsgo"
					return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers, { cwd = config.root_dir })
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				single_file_support = false,
				root_dir = function(bufnr, on_dir)
					local root = find_root(bufnr)
					if root then
						on_dir(root)
					end
				end,
			}
			-- Disable vtsls if tsgo is available
			opts.setup = opts.setup or {}
			opts.setup.vtsls = function()
				return find_root(0) ~= nil
			end
		end,
	},
}
