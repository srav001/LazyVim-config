return {
	{
		"zbirenbaum/copilot.lua",
		event = { "InsertEnter" },
		cmd = { "Copilot" },
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<C-l>",
					accept_word = false,
					accept_line = false,
					dismiss = "<C-]>",
				},
			},
		},
	},
	{
		"echasnovski/mini.move",
		version = "*",
		config = function()
			require("mini.move").setup()
		end,
		event = "VeryLazy",
	},
	{
		"mg979/vim-visual-multi",
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
}
