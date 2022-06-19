vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_borders = true

vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_italic_keywords = true
vim.g.tokyonight_style = "day"
vim.g.tokyonight_transparent = false

-- vim.g.one_nvim_transparent_bg = true

-- vim.cmd([[
-- try
--   colorscheme nord
-- catch /^Vim\%((\a\+)\)\=:E185/
--   colorscheme default
--   set background=dark
-- endtry
-- ]])

local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
	return
end

onedark.setup({
	style = "darker",
	transparent = false,
	term_colors = true, -- Change terminal color as per the selected theme style
	ending_tildes = true,
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
		background = false, -- use background color for virtual text
	},

	colors = {}, -- Override default colors
	highlights = {
		-- TSKeyword = { fg = "$green" },
		-- TSString = { fg = "#afe", bg = "#00ff00", fmt = "bold" },
		-- TSFunction = { fg = "#0000ff", sp = "$cyan", fmt = "underline,italic" },
	},
})

onedark.load()
