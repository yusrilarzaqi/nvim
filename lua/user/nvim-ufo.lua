vim.o.foldcolumn = "1"
vim.o.foldlevel = 10 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldenable = true

vim.cmd([[
hi default link UfoPreviewSbar PmenuSbar
hi default link UfoPreviewThumb PmenuThumb
hi default link UfoFoldedEllipsis Comment
]])

local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
	return
end

ufo.setup({
	open_fold_hl_timeout = 150,
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
		},
	},
	provider_selector = function(bufnr, filetype, buftype)
		--[[ return { "treesitter", "indent" } ]]
		return "indent"
	end,
})

vim.keymap.set("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- nvimlsp
		vim.lsp.buf.hover()
	end
end)
