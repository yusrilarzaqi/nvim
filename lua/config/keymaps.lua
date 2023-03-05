local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", '<cmd>lua require("which-key").show(" ", {mode = "n", auto = true})<cr>', opts)
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

-- Tab
keymap("n", "gn", ":tabnext<cr>", opts)
keymap("n", "gp", ":tabprevious<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
keymap(
	"n",
	"<S-m>",
	"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
	opts
)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- save file
keymap("n", "<C-s>", "<cmd>w!<CR>", opts)
keymap("i", "<C-s>", "<Esc><cmd>w!<CR>", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)

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

-- Visual Block --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
-- Move text up and down

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- BufferLineGoToBuffer
keymap("n", "<A-1>", "<cmd>lua require('bufferline').go_to_buffer(1, true)<cr>", opts)
keymap("n", "<A-2>", "<Cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", opts)
keymap("n", "<A-3>", "<Cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", opts)
keymap("n", "<A-4>", "<Cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", opts)
keymap("n", "<A-5>", "<Cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", opts)
keymap("n", "<A-6>", "<Cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", opts)
keymap("n", "<A-7>", "<Cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", opts)
keymap("n", "<A-8>", "<Cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", opts)
keymap("n", "<A-9>", "<Cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", opts)
keymap("n", "<A-$>", "<Cmd>lua require('bufferline').go_to_buffer(-1, true)<CR>", opts)

-- Close buffers
keymap("n", "<A-q>", "<cmd>Bdelete!<CR>", opts)

-- opens telescope find file
keymap(
	"n",
	"<C-P>",
	-- "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
	"<cmd>lua require('telescope.builtin').find_files()<cr>",
	opts
)
-- Telescope
keymap("n", "<C-n>", "<cmd>Telescope file_browser theme=ivy<cr>", opts)
keymap(
	"n",
	"<C-_>",
	"<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending prompt_position=top<cr>",
	opts
)

-- hover nvim_treesitter playground
keymap("n", "<C-i>", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)

--[[ vim.api.nvim_command("set foldmethod=expr") ]]
--[[ vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()") ]]
-- hlslens
-- keymap("n", "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", opts)
-- keymap("n", "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", opts)
-- keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", opts)
-- keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
-- keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
-- keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- vim.keymap.set("n", "zR", require("ufo").openAllFolds)
-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- dap
keymap(
	"n",
	"<F5>",
	"<cmd>lua require('telescope').extensions.dap.configurations(require('telescope.themes').get_dropdown{previewer = false})<CR>",
	opts
)
-- split
-- Split window
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

-- close buffer
keymap("n", "<leader>q", "<cmd>clo<cr>", opts)
