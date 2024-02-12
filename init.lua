local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Space>", "", opts)

-- Settings
vim.g.mapleader = " "
vim.g.localleader = " "
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true

-- Keymaps
keymap("n", "<leader>e", ":Neotree<CR>")
keymap("n", "<leader>l", ":Lazy<CR>")
keymap("n", "<leader>gg", ":LazyGit<CR>")
keymap("n", "<leader>dd", ":LazyDocker<CR>")

-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

