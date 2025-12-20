local function find_root(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" then
		return nil
	end
	local dir = vim.fs.dirname(file)
	-- Look for oxlint config files or the binary
	local config = vim.fs.find({ ".oxlintrc.json", "oxlintrc.json", ".oxlint.json" }, {
		path = dir,
		upward = true,
		stop = vim.env.HOME,
	})[1]
	if config then
		local root = vim.fs.dirname(config)
		-- Verify binary exists at this root
		if vim.uv.fs_stat(root .. "/node_modules/.bin/oxc_language_server") then
			return root
		end
	end
	-- Fallback: look for binary directly
	local bin = vim.fs.find("node_modules/.bin/oxc_language_server", {
		path = dir,
		upward = true,
		stop = vim.env.HOME,
	})[1]
	return bin and vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(bin))) or nil
end

local settings = {
	run = "onType",
	typeAware = true,
	fixKind = "safe_fix",
}

return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				oxc = {
					mason = false,
					settings = { oxc = settings, oxc_language_server = settings },
					cmd = function(dispatchers, config)
						local bin = config.root_dir .. "/node_modules/.bin/oxc_language_server"
						return vim.lsp.rpc.start({ bin }, dispatchers, { cwd = config.root_dir })
					end,
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					single_file_support = false,
					root_dir = function(bufnr, on_dir)
						local root = find_root(bufnr)
						if root then
							on_dir(root)
						end
					end,
				},
			},
		},
	},
}
