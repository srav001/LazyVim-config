return {
	{
		"neo-tree.nvim",
		opts = {
			window = {
				position = "float",
			},
		},
	},
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},
	{
		"echasnovski/mini.move",
		version = "*",
		opts = {},
		event = "VeryLazy",
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},
}
