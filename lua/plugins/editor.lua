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
		lazy = false,
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
		"nvim-mini/mini.move",
		version = "*",
		opts = {},
		event = "VeryLazy",
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},
	-- {
	-- 	"rachartier/tiny-inline-diagnostic.nvim",
	-- 	event = "VeryLazy", -- Or `LspAttach`
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("tiny-inline-diagnostic").setup()
	-- 		vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
	-- 	end,
	-- },
}
