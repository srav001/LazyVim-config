return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = { "InsertEnter" },
	-- 	cmd = { "Copilot" },
	-- 	opts = {
	-- 		suggestion = {
	-- 			enabled = true,
	-- 			auto_trigger = true,
	-- 			debounce = 75,
	-- 			keymap = {
	-- 				accept = "<C-l>",
	-- 				accept_word = false,
	-- 				accept_line = false,
	-- 				dismiss = "<C-o>",
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"supermaven-inc/supermaven-nvim",
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
	{
		"rcarriga/nvim-notify",
		enabled = false,
	},
	{
		"echasnovski/mini.ai",
		enabled = false,
	},
}
