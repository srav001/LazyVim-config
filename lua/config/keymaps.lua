-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.del("n", "<leader>l")

vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":W", ":w")
vim.keymap.set("n", ";W", ":w")
vim.keymap.set("n", "DD", "dd")
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<S-tab>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<leader>n", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>")
vim.keymap.set("n", "<leader>sz", "<cmd> Telescope current_buffer_fuzzy_find <CR>")

-- vim.keymap.del("n", "<leader>/")
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
end)

vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>")
