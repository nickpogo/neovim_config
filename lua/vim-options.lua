vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

-- paste the system clipboard
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Change buffer
-- vim.api.nvim_set_keymap("n", "<C-Up>", ":bnext<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-Down>", ":bprevious<CR>", { noremap = true, silent = true })


-- Navigate to the buffer above
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = "Move to the buffer above", noremap = true, silent = true })
-- Navigate to the buffer below
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = "Move to the buffer below", noremap = true, silent = true })
-- Navigate to the buffer to the left
vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = "Move to the buffer on the left", noremap = true, silent = true })
-- Navigate to the buffer to the right
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = "Move to the buffer on the right", noremap = true, silent = true })

-- Set the key mapping for quitting
vim.keymap.set("", "<leader>q", "<cmd>q<cr>", { desc = "Quit", noremap = true, silent = true })
-- Set the key mapping for writing
vim.keymap.set("", "<leader>w", "<cmd>w<cr>", { desc = "Write", noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})


-- -- something abbout wrapping in markdown
-- vim.opt.formatoptions = "jcroqlntw"
-- vim.opt.textwidth = 80
-- vim.opt_local.wrap = true
-- vim.cmd([[autocmd FileType markdown set tw=80 wrap]])
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
-- 		vim.opt.shiftwidth = 2
-- 		vim.opt.tabstop = 2
-- 		vim.opt.softtabstop = 2
-- 	end,
-- })
