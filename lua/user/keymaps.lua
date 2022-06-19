local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- save file
keymap("n", "<C-s>", "<cmd>w!<CR>", opts)
keymap("i", "<C-s>", "<Esc><cmd>w!<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- copy
keymap("v", "<C-c>", '"+y', opts)
keymap("x", "<C-c>", '"+y', opts)

keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
-- Visual Block --
-- Move text up and down

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- BufferLineGoToBuffer
-- nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
keymap("n", "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
keymap("n", "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
keymap("n", "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
keymap("n", "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
keymap("n", "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
keymap("n", "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
keymap("n", "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)

-- Close buffers
keymap("n", "<A-q>", "<cmd>Bdelete!<CR>", opts)

-- opens telescope find file

keymap(
	"n",
	"<C-P>",
	"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
	opts
)

-- vim.api.nvim_command("set foldmethod=expr")
-- vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
