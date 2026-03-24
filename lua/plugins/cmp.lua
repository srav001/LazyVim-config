return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		opts = {
			completion = {
				list = {
					selection = { preselect = false, auto_insert = true },
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
