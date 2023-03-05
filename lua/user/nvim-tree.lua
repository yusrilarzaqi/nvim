-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- vim.g.nvim_tree_icons = {
local icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "",
		staged = "",
		unmerged = "",
		renamed = "凜",
		deleted = "",
		untracked = "U",
		ignored = "◌",

		--[[ unstaged = "", ]]
		-- unstaged = "✗",
		--[[ staged = "✓", ]]
		-- staged = "S",
		--[[ renamed = "➜", ]]
		-- untracked = "ﲉ",
	},
	folder = {
		arrow_open = "",
		arrow_closed = "",
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
		symlink_open = "",

		--[[ empty_open = "", ]]
		-- open = "",
		--[[ arrow_open = "", ]]
		--[[ arrow_closed = "", ]]
		-- default = "",
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
	hijack_cursor = true,
	update_cwd = true,
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
	},
	filters = {
		dotfiles = true,
		custom = { "^.git$", "__pycache__", "node_modules", "^\\.cache$" },
	},
	system_open = { cmd = nil, args = {} },
	git = {
		ignore = false,
	},
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
		float = {
			enable = ture,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	renderer = {
		highlight_git = true,
		highlight_opened_files = "bold",
		full_name = false,
		root_folder_modifier = ":t",
		group_empty = true,
		indent_width = 2,
		indent_markers = {
			enable = true,
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
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
})
