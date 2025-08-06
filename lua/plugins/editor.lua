return {
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	opts = {
	-- 		window = {
	-- 			position = "float",
	-- 		},
	-- 	},
	-- },
	{
		"snacks.nvim",
		opts = {
			picker = {
				sources = {
					explorer = {
						layout = { preset = "right", preview = false },
					},
				},
			},
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
