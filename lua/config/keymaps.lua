vim.keymap.del("n", "<leader>l")

vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":W", ":w")
vim.keymap.set("n", ";W", ":w")
vim.keymap.set("n", "DD", "dd")
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<S-tab>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<leader>n", "<cmd>tabprevious<cr>")

vim.keymap.set("n", "r", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "R", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>LspRestart<cr>")
