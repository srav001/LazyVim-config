return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
	{
		"snacks.nvim",
		opts = {
			notifier = { enabled = false },
		},
	},
	{
		"echasnovski/mini.ai",
		enabled = false,
	},
	-- AI items
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",

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

		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change

		opts = {
			provider = "openai",
			auto_suggestions_provider = "openai",
		},
		build = "make",

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",

				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
