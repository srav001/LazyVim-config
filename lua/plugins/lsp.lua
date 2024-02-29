return {
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },

	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
						-- [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
						-- [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
					},
				},
			},
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
					opts.settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					}
				end,
				---@class lspconfig.options.volar
				-- volar = function(_, opts)
				-- 	opts.filetypes =
				-- 		{ "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" }
				-- 	opts.settings = {
				-- 		typescript = {
				-- 			inlayHints = {
				-- 				enumMemberValues = {
				-- 					enabled = true,
				-- 				},
				-- 				functionLikeReturnTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				includeInlayFunctionParameterTypeHints = {
				-- 					enabled = true,
				-- 				},
				-- 				parameterNames = {
				-- 					enabled = true,
				-- 					suppressWhenArgumentMatchesName = true,
				-- 				},
				-- 				parameterTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				propertyDeclarationTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				includeInlayFunctionLikeReturnTypeHints = {
				-- 					enabled = true,
				-- 				},
				-- 				variableTypes = {
				-- 					enabled = true,
				-- 				},
				-- 			},
				-- 		},
				-- 		javascript = {
				-- 			inlayHints = {
				-- 				enumMemberValues = {
				-- 					enabled = true,
				-- 				},
				-- 				functionLikeReturnTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				includeInlayFunctionParameterTypeHints = {
				-- 					enabled = true,
				-- 				},
				-- 				parameterNames = {
				-- 					enabled = true,
				-- 					suppressWhenArgumentMatchesName = true,
				-- 				},
				-- 				parameterTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				propertyDeclarationTypes = {
				-- 					enabled = true,
				-- 				},
				-- 				includeInlayFunctionLikeReturnTypeHints = {
				-- 					enabled = true,
				-- 				},
				-- 				variableTypes = {
				-- 					enabled = true,
				-- 				},
				-- 			},
				-- 		},
				-- 	}
				-- end,
				-- Specify * to use this function as a fallback for any server
				["*"] = function(server, opts) end,
			},
		},
	},
}
