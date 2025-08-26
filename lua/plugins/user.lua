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
	-- https://github.com/LazyVim/LazyVim/pull/6354#issuecomment-3202799735
	{
		"akinsho/bufferline.nvim",
		init = function()
			local bufline = require("catppuccin.groups.integrations.bufferline")
			function bufline.get()
				return bufline.get_theme()
			end
		end,
	},
}
