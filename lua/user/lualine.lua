-- gps
local status_ok_gps, gps = pcall(require, "nvim-gps")
if not status_ok_gps then
	return
end

local function gps_content()
	local opts = {
		disable_icons = false,
		separator = " > ",
		depth = 0,
		depth_limit_indicator = "..",
	}
	if gps.is_available() then
		-- return gps.get_location()
		return gps.get_location(opts)
	else
		return ""
	end
end

local gps_line = {
	gps_content,
	-- cond = gps.is_available,
}

-- python env
local function python_venv()
	local function env_cleanup(venv)
		if string.find(venv, "/") then
			local final_venv = venv
			for w in venv:gmatch("([^/]+)") do
				final_venv = w
			end
			venv = final_venv
		end
		return venv
	end

	if vim.bo.filetype == "python" then
		local venv = os.getenv("CONDA_DEFAULT_ENV")
		if venv then
			return string.format("%s", env_cleanup(venv))
		end
		venv = os.getenv("VIRTUAL_ENV")
		if venv then
			return string.format("%s", env_cleanup(venv))
		end
	end
	return ""
end

-- lualine
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 15
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = { error = " ", warn = " ", info = "", hint = " " },
	colored = true,
	update_in_insert = true,
	always_visible = false,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = "+", modified = "~", removed = "-" },
	cond = conditions.hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		return str:sub(1, 1)
	end,
	-- separator = { left = "", right = "" },
	-- separator = { right = "", left = "" },
	padding = 1,
}

local filetype = {
	"filetype",
	-- icons_enabled = true,
	icon_only = true,
	-- icon = nil,
}

-- local filesize = {
-- 	"filesize",
-- 	cond = conditions.buffer_not_empty,
-- }

local branch = {
	"branch",
	-- icons_enabled = true,
	-- icon = " שׂ",
	icon = "",
	-- icon = "  ",
	-- icon = "",
	cond = conditions.buffer_not_empty,
}
-- local location = {
-- 	"location",
-- 	padding = 1,
-- 	colored = true,
-- 	separator = { left = "", right = "" },
-- }

local fileformat = {
	"fileformat",
	symbols = {
		unix = " ", -- e712
		dos = " ", -- e70f
		mac = " ", -- e711
		bsd = " ",
	},
	-- colored = false,
}

local filename = {
	"filename",
	file_status = true, -- Displays file status (readonly status, modified status)
	-- 0: Just the filename
	-- 1: Relative path
	-- 2: Absolute path
	path = 0,

	shorting_target = 40, -- Shortens path to leave 40 spaces in the window
	-- for other components. (terrible name, any suggestions?)
	symbols = {
		modified = " [+]", -- Text to show when the file is modified.
		readonly = " [!]", -- Text to show when the file is non-modifiable or readonly.
		unnamed = " [No Name]", -- Text to show for unnamed buffers.
	},
	color = { fg = "#87afaf" },
}

local encoding = {
	"encoding",
	fmt = string.upper,
}

-- cool function for progress
-- local progress = function()
-- 	local current_line = vim.fn.line(".")
-- 	local total_lines = vim.fn.line("$")
-- 	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
-- 	local line_ratio = current_line / total_lines
-- 	local index = math.ceil(line_ratio * #chars)
-- 	return chars[index]
-- end

-- local spaces = function()
-- return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
-- end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		-- component_separators = { left = '', right = ''},
		component_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
		-- section_separators = { left = "▀", right = "▀" },
		-- section_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, diff },
		lualine_c = { diagnostics, gps_line },
		lualine_x = { filetype, filename },
		lualine_y = { encoding, fileformat },
		lualine_z = { python_venv },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { filename },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
