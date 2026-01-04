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

-- Derive patterns and filetypes
local patterns, filetypes = {}, {}
local seen = {}
for ext, ft in pairs(extensions) do
	patterns[#patterns + 1] = "*." .. ext
	if not seen[ft] then
		seen[ft] = true
		filetypes[#filetypes + 1] = ft
	end
end

local function is_ts_file(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local ext = name:match("%.([^%.]+)$")
	return ext and extensions[ext] ~= nil
end

local function find_root(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" then
		return nil
	end
	local bin = vim.fs.find("node_modules/.bin/tsgo", {
		path = vim.fs.dirname(file),
		upward = true,
		stop = vim.env.HOME,
	})[1]
	if not bin then
		return nil
	end
	local root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(bin)))
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
		functionLikeReturnTypes = { enabled = false },
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = false },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

local refresh_timer = nil
local function refresh_diagnostics()
	if refresh_timer then
		refresh_timer:stop()
	end
	refresh_timer = vim.defer_fn(function()
		local clients = vim.lsp.get_clients({ name = "tsgo" })
		if #clients == 0 then
			return
		end
		local client = clients[1]
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local is_valid = vim.api.nvim_buf_is_valid(buf)
				and (vim.api.nvim_buf_is_loaded(buf) or vim.fn.buflisted(buf) == 1)
				and vim.bo[buf].buftype == ""
				and is_ts_file(buf)
			if is_valid then
				client:request("textDocument/diagnostic", {
					textDocument = { uri = vim.uri_from_bufnr(buf) },
				}, function(err, result, ctx)
					if err or not result then
						return
					end
					vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
				end, buf)
			end
		end
	end, 50)
end

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
				filetypes = filetypes,
				single_file_support = false,
				root_dir = function(bufnr, on_dir)
					local root = find_root(bufnr)
					if root then
						on_dir(root)
					end
				end,
			}
			opts.setup = opts.setup or {}
			opts.setup.vtsls = function()
				return find_root(0) ~= nil
			end
		end,
		init = function()
			vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, {
				group = vim.api.nvim_create_augroup("TsgoPullDiagnostics", { clear = true }),
				pattern = patterns,
				callback = refresh_diagnostics,
			})
		end,
	},
}
