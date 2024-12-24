return {
	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				list = {
					selection = "auto_insert",
				},
			},
			keymap = {
				preset = "none",
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			},
		},
	},
}
