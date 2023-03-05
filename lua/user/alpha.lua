local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[██  ██  ██  ██  ██████  ██████  ██  ██      ██████  ██████  ███████  ██████  ██████   ██]],
	[[██▄ ██  ██  ██  ██▄     ██  ██  ██  ██      ██  ██  ██  ██      ▄██  ██  ██  ██  ██   ██]],
	[[ ▀██▀   ██  ██  ██████  ██████  ██  ██      ██████  ██████   ▄███▀   ██████  ██  ██   ██]],
	[[  ██    ██▄ ██     ▄██  ███▄    ██  ██      ██  ██  ████▄   ██▀▀     ██  ██  ██ ▄██   ██]],
	[[  ██    ██████  ██████  ██ ▀█▄  ██  ██████  ██  ██  ██ ▀█▄  ███████  ██  ██  ██████▄  ██]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <CR>"),
	dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

-- local Job = require("plenary.job")

--Job
--	:new({
--		"curl",
--		"wttr.in/Ungaran?format=%C+%f&lang=id",
--		on_exit = function(j, _)
--			--[[ print(vim.inspect(j:result()[1])) ]]
--			--[[ local footer_text = j:result()[1] ]]
--			dashboard.section.footer.val = j:result()[1]
--		end,
--	})
--	:start() -- or start()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
--  vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
