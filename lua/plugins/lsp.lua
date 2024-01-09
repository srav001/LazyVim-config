return {
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },

	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				---@class lspconfig.options.volar
				volar = function(_, opts)
					opts.filetypes =
						{ "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json", "svelte" }
					opts.settings = {
						typescript = {
							inlayHints = {
								enumMemberValues = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								includeInlayFunctionParameterTypeHints = {
									enabled = true,
								},
								parameterNames = {
									enabled = true,
									suppressWhenArgumentMatchesName = true,
								},
								parameterTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								includeInlayFunctionLikeReturnTypeHints = {
									enabled = true,
								},
								variableTypes = {
									enabled = true,
								},
							},
						},
						javascript = {
							inlayHints = {
								enumMemberValues = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								includeInlayFunctionParameterTypeHints = {
									enabled = true,
								},
								parameterNames = {
									enabled = true,
									suppressWhenArgumentMatchesName = true,
								},
								parameterTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								includeInlayFunctionLikeReturnTypeHints = {
									enabled = true,
								},
								variableTypes = {
									enabled = true,
								},
							},
						},
					}
				end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
	},
}
