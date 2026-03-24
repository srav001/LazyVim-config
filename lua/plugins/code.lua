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
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
	},
}
