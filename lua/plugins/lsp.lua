return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"svelte@0.17.0",
			},
		},
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
	{
		"folke/trouble.nvim",
		opts = { use_diagnostic_signs = true },
	},
}
