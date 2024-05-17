return {
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     -- set default server config to use nvim-vtsls one, which would allow use to use the plugin
  --     require("lspconfig.configs").vtsls = require("vtsls").lspconfig
  --
  --     opts.diagnostics = {
  --       underline = true,
  --       update_in_insert = false,
  --       virtual_text = {
  --         spacing = 4,
  --         source = "if_many",
  --         prefix = "●",
  --       },
  --     }
  --     opts.severity_sort = true
  --     opts.signs = {
  --       text = {
  --         [vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
  --         [vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
  --         -- [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
  --         -- [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
  --       },
  --     }
  --
  --     -- ---@type lspconfig.options.vtsls
  --     opts.servers.vtsls = {
  --       -- you can view all keys here: https://github.com/yioneko/nvim-vtsls#commands
  --       -- this keymaps will only appear at the lsp filetype (TypeScript, JavaScript). So they won't interfere with your other keymaps
  --       keys = {
  --         {
  --           "<leader>co",
  --           function()
  --             require("vtsls").commands.organize_imports(0)
  --           end,
  --           desc = "Organize Imports",
  --         },
  --         {
  --           "<leader>cM",
  --           function()
  --             require("vtsls").commands.add_missing_imports(0)
  --           end,
  --           desc = "Add missing imports",
  --         },
  --         {
  --           "<leader>cD",
  --           function()
  --             require("vtsls").commands.fix_all(0)
  --           end,
  --           desc = "Fix all diagnostics",
  --         },
  --         {
  --           "<leader>cLL",
  --           function()
  --             require("vtsls").commands.open_tsserver_log()
  --           end,
  --           desc = "Open Vtsls Log",
  --         },
  --         {
  --           "<leader>cR",
  --           function()
  --             require("vtsls").commands.rename_file(0)
  --           end,
  --           desc = "Rename File",
  --         },
  --         {
  --           "<leader>cu",
  --           function()
  --             require("vtsls").commands.file_references(0)
  --           end,
  --           desc = "Show File Uses(References)",
  --         },
  --         {
  --           "<leader>ctc",
  --           function()
  --             require("vtsls").commands.goto_project_config(0)
  --           end,
  --           desc = "Open Project Config",
  --         },
  --       },
  --       settings = {
  --         vtsls = {
  --           experimental = {
  --             completion = {
  --               enableServerSideFuzzyMatch = true,
  --             },
  --           },
  --         },
  --         javascript = {
  --           format = {
  --             indentSize = vim.o.shiftwidth,
  --             convertTabsToSpaces = vim.o.expandtab,
  --             tabSize = vim.o.tabstop,
  --           },
  --           -- enables inline hints
  --           inlayHints = {
  --             parameterNames = { enabled = "literals" },
  --             parameterTypes = { enabled = true },
  --             variableTypes = { enabled = true },
  --             propertyDeclarationTypes = { enabled = true },
  --             functionLikeReturnTypes = { enabled = true },
  --             enumMemberValues = { enabled = true },
  --           },
  --           -- otherwise it would ask every time if you want to update imports, which is a bit annoying
  --           updateImportsOnFileMove = {
  --             enabled = "always",
  --           },
  --         },
  --         typescript = {
  --           format = {
  --             indentSize = vim.o.shiftwidth,
  --             convertTabsToSpaces = vim.o.expandtab,
  --             tabSize = vim.o.tabstop,
  --           },
  --           updateImportsOnFileMove = {
  --             enabled = "always",
  --           },
  --           inlayHints = {
  --             parameterNames = { enabled = "literals" },
  --             parameterTypes = { enabled = true },
  --             variableTypes = { enabled = true },
  --             propertyDeclarationTypes = { enabled = true },
  --             functionLikeReturnTypes = { enabled = true },
  --             enumMemberValues = { enabled = true },
  --           },
  --         },
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     {
  --       "yioneko/nvim-vtsls",
  --       handlers = {},
  --     },
  --   },
  -- },

  -- IF USING EXTRAS LANG TYPESCRIPT !!!!
  { import = "lazyvim.plugins.extras.lang.typescript" },
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
      servers = {
        ---@class lspconfig.options.tsserver
        tsserver = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = "all",
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              updateImportsOnFileMove = {
                enabled = "always",
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = "all",
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
      -- setup = {
      ---@type fun(server:string, opts:lspconfig.options.volar)
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
      -- },
    },
  },
}
