-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "yp", '<cmd>let @+ = expand("%")<cr>', { desc = "Copy full path of current buffer" })
vim.keymap.set("n", "g/", "/\\%V", { desc = "VISUAL search" })
