return {
	-- Catppuccin breaking changes patch
	{
		"catppuccin/nvim",
		opts = function(_, opts)
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
			return opts
		end,
	},
	{
		"LazyVim/LazyVim",
		lazy = false,
		priority = 1000,
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
	{
		"echasnovski/mini.ai",
		enabled = false,
	},
	{
		"rcarriga/nvim-notify",
		enabled = false,
	},
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",

		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-l>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
			})
		end,
	},
}
