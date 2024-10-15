return {
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
	{ import = "lazyvim.plugins.extras.lang.svelte" },
	{ import = "lazyvim.plugins.extras.lang.vue" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"svelte@0.17.0",
			},
		},
	},
}
