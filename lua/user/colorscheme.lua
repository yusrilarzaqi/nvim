-- vim.cmd([[
-- try
--   colorscheme tokyonight
-- catch /^Vim\%((\a\+)\)\=:E185/
--   colorscheme default
--   set background=dark
-- endtry
-- ]])
--
-- Tokyonight
local v = vim.g
v.tokyonight_italic_functions = true
v.tokyonight_italic_keywords = true
v.tokyonight_style = "night"
v.tokyonight_transparent = false
v.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
-- Default options:

-- kanagawa
require("kanagawa").setup({
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = { italic = true },
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	variablebuiltinStyle = { italic = true },
	specialReturn = true, -- special highlight for the return keyword
	specialException = true, -- special highlight for exception handling keywords
	transparent = false, -- do not set background color
	dimInactive = true, -- dim inactive window `:h hl-NormalNC`
	globalStatus = true, -- adjust window separators highlight for laststatus=3
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = {
		sumiInk1 = "#1f1f28",
		bg = "#181820",
	},
	overrides = {},
})

local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
	return
end

onedark.setup({
	style = "deep",
	transparent = false,
	term_colors = true, -- Change terminal color as per the selected theme style
	ending_tildes = true,
	-- toggle theme style ---
	toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

	code_style = {
		comments = "italic",
		keywords = "italic",
		functions = "italic",
		strings = "none",
		variables = "none",
	},
	diagnostics = {
		darker = false, -- darker colors for diagnostic
		undercurl = true, -- use undercurl instead of underline for diagnostics
		background = true, -- use background color for virtual text
	},

	colors = {}, -- Override default colors
	highlights = {
		-- TSKeyword = { fg = "$green" },
		-- TSString = { fg = "#afe", bg = "#00ff00", fmt = "bold" },
		-- TSFunction = { fg = "#0000ff", sp = "$cyan", fmt = "underline,italic" },
	},
})

--[[ onedark.load() ]]

vim.cmd("colorscheme darkplus")
