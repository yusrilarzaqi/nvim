local status_ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
if not status_ok then
	return
end

nvim_web_devicons.setup({
	default = true,
})

local colors = require("kanagawa.colors").setup()
nvim_web_devicons.set_icon({
	py = {
		icon = "🐍",
		name = "py",
	},
	Dockerfile = {
		icon = "",
		color = colors.crystalBlue,
		cterm_color = "59",
		name = "Dockerfile",
	},
	mjs = {
		icon = "",
		color = colors.roninYellow,
		cterm_color = "185",
		name = "Js",
	},
})
