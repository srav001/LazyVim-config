return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		opts = {
			ensure_installed = {
				"bash",
				"html",
				"css",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"svelte",
				"tsx",
				"typescript",
				"vue",
				"yaml",
			},
		},
	},
	--   {
	--     "NvChad/nvim-colorizer.lua",
	--     optional = true,
	--     opts = {
	--       user_default_options = {
	--         names = true,
	--         tailwind = true,
	--       },
	--     },
	--   },
}
