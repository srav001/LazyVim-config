local tsgo_filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

local oxc_supported = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"json",
	"jsonc",
	"vue",
	"svelte",
	"astro",
}

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}

			if opts.servers.vtsls then
				opts.servers.vtsls.enabled = false
			end

			opts.servers.tsgo = {
				filetypes = tsgo_filetypes,
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = {
								enabled = "literals",
								suppressWhenArgumentMatchesName = true,
							},
							parameterTypes = { enabled = true },
							variableTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			}

			opts.servers.oxlint = opts.servers.oxlint or {}
			opts.servers.oxfmt = { enabled = false }
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"tsgo",
				"oxlint",
				--"oxfmt"
			})
		end,
	},
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		opts.formatters_by_ft = opts.formatters_by_ft or {}
	-- 		for _, ft in ipairs(oxc_supported) do
	-- 			opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
	-- 			table.insert(opts.formatters_by_ft[ft], "oxfmt")
	-- 		end
	-- 	end,
	-- },
}
