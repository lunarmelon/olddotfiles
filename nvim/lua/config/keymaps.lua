local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Directory navigation
keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Pane navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)  -- Navigate left
keymap.set("n", "<C-j>", "<C-w>j", opts)  -- Navigate down
keymap.set("n", "<C-k>", "<C-w>k", opts)  -- Navigate up
keymap.set("n", "<C-l>", "<C-w>l", opts)  -- Navigate right

-- Window management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- Split vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split horizontally
