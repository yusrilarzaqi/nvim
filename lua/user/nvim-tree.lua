-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- vim.g.nvim_tree_icons = {
local icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "",
		-- unstaged = "✗",
		-- staged = "S",
		staged = "✓",
		unmerged = "",
		renamed = "➜",
		deleted = "",
		-- untracked = "ﲉ",
		untracked = "U",
		ignored = "◌",
	},
	folder = {
		arrow_open = "",
		arrow_closed = "",
		--[[ arrow_open = "", ]]
		--[[ arrow_closed = "", ]]
		-- default = "",
		default = "",
		-- open = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
	},
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	sync_root_with_cwd = true,
	respect_buf_cwd = true,--[[ popup_border_style = "rounded", ]]
	auto_reload_on_write = true,
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		"alpha",
	},
	open_on_tab = false,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	update_cwd = true,
	--[[ update_to_buf_dir = { ]]
	--[[ 	enable = true, ]]
	--[[ 	auto_open = true, ]]
	--[[ }, ]]
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = " ",
		},
		show_on_dirs = true,
	},
	update_focused_file = {
		enable = true,
		update_root = true,
		update_cwd = false,
		--[[ ignore_list = {}, ]]
	},
	--[[ system_open = { ]]
	--[[ 	cmd = nil, ]]
	--[[ 	args = {}, ]]
	--[[ }, ]]
	filters = {
		dotfiles = true,
		custom = { "^.git$", "__pycache__" },
	},
	--[[ git = { ]]
	--[[ 	enable = true, ]]
	--[[ 	ignore = true, ]]
	--[[ 	timeout = 500, ]]
	--[[ }, ]]
	-- git_status = {
	-- 	window = {
	-- 		position = "float",
	-- 	},
	-- },
	view = {
		adaptive_size = true,
		hide_root_folder = true,
		side = "left",
		signcolumn = "yes",
		mappings = {
			custom_only = false,
			list = {
				{ key = "u", action = "dir_up" },
				{ key = "D", action = "dir_down" },
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "L", cb = tree_cb("cd") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
				{ key = "s", cb = tree_cb("split") },
				{ key = "t", cb = tree_cb("tabnew") },
				{ key = "i", cb = tree_cb("preview") },
			},
		},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	renderer = {
		highlight_git = false,
		highlight_opened_files = "none",
		group_empty = true,
		indent_markers = {
			enable = true,
			--[[ icons = { ]]
			--[[ 	-- └ ]]
			--[[ 	-- corner = "┗ ", ]]
			--[[ 	corner = "└", ]]
			--[[ 	-- corner = "└─", ]]
			--[[ 	-- edge = "|", ]]
			--[[ 	-- edge = "┃ ", ]]
			--[[ 	edge = "│", ]]
			--[[ 	-- edge = "▎", ]]
			--[[ 	-- edge = "│ ", ]]
			--[[ 	none = "", ]]
			--[[ }, ]]
		},
		icons = {
			webdev_colors = true,
			git_placement = "after",
			show = {
				folder_arrow = false,
			},
			glyphs = icons,
		},
	},
})
