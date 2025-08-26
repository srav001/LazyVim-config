return {
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
