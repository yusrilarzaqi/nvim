--[[ local colors = require("kanagawa.colors").setup() ]]
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

bufferline.setup({
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator = {
			icon = "▎",
			style = "icon", -- underline , icon none
		},
		modified_icon = "●",
		buffer_close_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = true,
		diagnostics_indicator = function(count) -- (count, level, diagnostics_dict, context)
			--[[ local icon = level:match("error") and " " or " " ]]
			-- return " " .. icon .. count
			return "[" .. count .. "]"
		end,

		offsets = {
			{
				filetype = "NvimTree",
				--[[ text = function() ]]
				--[[ 	return vim.fn.getcwd() ]]
				--[[ end, ]]
				text = " File Manager",
				highlight = "Directory",
				text_align = "center",
			},
		},
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' }, "`padded_slant`" "slant" ]]
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		hover = {
			enabled = false,
			delay = 200,
			reveal = { "close" },
		},
	},

	--[[ highlights = { ]]
	--[[ 	fill = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "#fff" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	background = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	buffer_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "#ff0000" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "#0000ff" }, ]]
	--[[ 		gui = "none", ]]
	--[[ 	}, ]]
	--[[ 	buffer_visible = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	close_button = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	close_button_visible = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	close_button_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLineSel" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLineSel" }, ]]
	--[[ 	}, ]]
	--[[ 	tab_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "Normal" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 	}, ]]
	--[[ 	tab = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	tab_close = { ]]
	--[[ 		--[[ guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultError" }, ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLineSel" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 	}, ]]
	--[[]]
	--[[ 	duplicate_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLineSel" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLineSel" }, ]]
	--[[ 		gui = "italic", ]]
	--[[ 	}, ]]
	--[[ 	duplicate_visible = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 		gui = "italic", ]]
	--[[ 	}, ]]
	--[[ 	duplicate = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 		gui = "italic", ]]
	--[[ 	}, ]]
	--[[ 	modified = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	modified_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "Normal" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 	}, ]]
	--[[ 	modified_visible = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	separator = { ]]
	--[[ 		guifg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	separator_selected = { ]]
	--[[ 		guifg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 	}, ]]
	--[[ 	separator_visible = { ]]
	--[[ 		guifg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "TabLine" }, ]]
	--[[ 	}, ]]
	--[[ 	indicator_selected = { ]]
	--[[ 		guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" }, ]]
	--[[ 		guibg = { attribute = "bg", highlight = "Normal" }, ]]
	--[[ 	}, ]]
	--[[ }, ]]

	highlights = {
		tab_close = {
			fg = "#C34043",
		},

		close_button = {
			fg = "#C34043",
		},
		close_button_visible = {
			fg = "#C34043",
		},
		close_button_selected = {
			fg = "#C34043",
		},

		offset_separator = {
			fg = "#ffffff",
			bg = "#ffffff",
		},
	},
})
