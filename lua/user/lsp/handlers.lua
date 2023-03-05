local status_ok_navic, navic = pcall(require, "nvim-navic")
if not status_ok_navic then
	return
end

local M = {}

-- TODO: backfill this to template
M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = " " },
		{ name = "DiagnosticSignWarn", text = " " },
		{ name = "DiagnosticSignHint", text = " " },
		{ name = "DiagnosticSignInfo", text = " " },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = {
			--[[ prefix = "● ", ]]
			prefix = " ",
			--[[ prefix = "⭘ ", ]]
			--[[ prefix = " ", ]]
			--[[ prefix = "ﱪ ", ]]
		},
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "single",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single", -- rounded
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single", -- rounded
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references theme=dropdown<CR>", opts)
	keymap(bufnr, "n", "fn", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	-- keymap(bufnr, "n", "gl", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	keymap(bufnr, "n", "<c-q>", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	-- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" or client.name == "jsonls" or client.name == "html" or client.name == "luals" then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ufo
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }

capabilities.textDocument.foldingRange = {
	dynamicRegistration = true,
	lineFoldingOnly = true,
}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local lsp_util = vim.lsp.util

function M.code_action_listener()
	local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
	local params = lsp_util.make_range_params()
	params.context = context
	vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, _, result) end)
end

-- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])
-- vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

return M
