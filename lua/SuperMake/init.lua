local ui = require("SuperMake.ui")


local M = {}

vim.keymap.set("n", "<leader>m", ui.open)
vim.keymap.set("n", "<leader>C", ":!rm ~/.local/share/nvim/SuperMake/*")

return M
