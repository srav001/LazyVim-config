vim.g.ai_cmp = false

-- Root detection: .git first, then LSP, then cwd
vim.g.root_spec = { ".git", "lsp", "cwd" }

local opt = vim.opt
-- opt.completeopt = "noselect"
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.wrap = true
