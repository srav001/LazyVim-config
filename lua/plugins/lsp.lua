return {
	{
		"simrat39/symbols-outline.nvim",
		event = "VeryLazy",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
	{
		"folke/trouble.nvim",
		event = "BufRead",
		opts = { use_diagnostic_signs = true },
	},
	-- :MasonInstall vue-language-server@2.2.8
}
