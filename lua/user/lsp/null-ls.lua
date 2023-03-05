local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	debug = true,
	sources = {
		formatting.prettier.with({
			extra_args = { "--single-quote", "--jsx-single-quote", "--use-tabs" },
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		code_actions.eslint,
		code_actions.gitsigns,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ async = true })
				end,
			})
		end
	end,
})
