local FIX_ON_SAVE = true

local extensions = {
	ts = "typescript",
	tsx = "typescriptreact",
	js = "javascript",
	jsx = "javascriptreact",
	mts = "typescript",
	cts = "typescript",
	mjs = "javascript",
	cjs = "javascript",
}

-- Derive filetypes and patterns
local filetypes, patterns = {}, {}
local seen = {}
for ext, ft in pairs(extensions) do
	patterns[#patterns + 1] = "*." .. ext
	if not seen[ft] then
		seen[ft] = true
		filetypes[#filetypes + 1] = ft
	end
end

local function refresh_diagnostics()
	local buf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf, name = "oxc" })
	if #clients == 0 then
		return
	end
	local client = clients[1]
	client:request("textDocument/diagnostic", {
		textDocument = { uri = vim.uri_from_bufnr(buf) },
	}, function(err, result, ctx)
		if err or not result then
			return
		end
		vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
	end, buf)
end

local function find_root(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" then
		return nil
	end
	local dir = vim.fs.dirname(file)
	local config = vim.fs.find({ ".oxlintrc.json", "oxlintrc.json", ".oxlint.json" }, {
		path = dir,
		upward = true,
		stop = vim.env.HOME,
	})[1]
	if config then
		local root = vim.fs.dirname(config)
		if vim.uv.fs_stat(root .. "/node_modules/.bin/oxc_language_server") then
			return root
		end
	end
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
					filetypes = filetypes,
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
		init = function()
			local group = vim.api.nvim_create_augroup("OxcDiagnostics", { clear = true })

			vim.api.nvim_create_autocmd("FocusGained", {
				group = group,
				pattern = patterns,
				callback = refresh_diagnostics,
			})

			if not FIX_ON_SAVE then
				return
			end
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				pattern = patterns,
				callback = function(ev)
					local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "oxc" })
					if #clients == 0 then
						return
					end
					vim.lsp.buf.code_action({
						context = { only = { "source.fixAll.oxc" }, diagnostics = {} },
						apply = true,
					})
				end,
			})
		end,
	},
}
