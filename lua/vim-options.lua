vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

-- paste the system clipboard
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- something abbout wrapping in markdown
vim.opt.formatoptions = "jcroqlntw"
vim.opt.textwidth = 80
vim.opt_local.wrap = true
vim.cmd([[autocmd FileType markdown set tw=80 wrap]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})
