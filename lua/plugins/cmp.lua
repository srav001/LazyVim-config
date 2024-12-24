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
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			},
		},
	},
}
