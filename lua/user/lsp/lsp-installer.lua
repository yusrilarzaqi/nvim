local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
		lsp_flags = { debounce_text_changes = 150 },
	}

	-- if server.name == "jsonls" then
	-- 	local jsonls_opts = require("user.lsp.settings.jsonls")
	-- 	opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	-- end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server.name == "pyright" then
		local pyright_opts = require("user.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server.name == "tsserver" then
		local tsserver_pts = require("user.lsp.settings.tsserver")
		opts = vim.tbl_deep_extend("force", tsserver_pts, opts)
	end

	if server.name == "cssls" then
		local cssls_opts = require("user.lsp.settings.cssls")
		opts = vim.tbl_deep_extend("force", cssls_opts, opts)
	end

	if server.name == "html" then
		local html_opts = require("user.lsp.settings.html")
		opts = vim.tbl_deep_extend("force", html_opts, opts)
	end

	if server.name == "emmet_ls" then
		local emmet_opts = require("user.lsp.settings.emmet_ls")
		opts = vim.tbl_deep_extend("force", emmet_opts, opts)
	end

	if server.name == "eslint" then
		local eslint_pts = require("user.lsp.settings.eslint")
		opts = vim.tbl_deep_extend("force", eslint_pts, opts)
	end

	if server.name == "gopls" then
		local gopls_pts = require("user.lsp.settings.gopls")
		opts = vim.tbl_deep_extend("force", gopls_pts, opts)
	end

	if server.name == "marksman" then
		local marksman_pts = require("user.lsp.settings.marksman")
		opts = vim.tbl_deep_extend("force", marksman_pts, opts)
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
