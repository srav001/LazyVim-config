return {
	{ import = "lazyvim.plugins.extras.coding.copilot" },
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
		event = "User AstroFile",
	},
}
