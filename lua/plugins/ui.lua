return {
  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local status_ok_navic, navic = pcall(require, "nvim-navic")
      if not status_ok_navic then
        return
      end

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
        --[[ symbols = { error = " ", warn = " ", info = " ", hint = " " }, ]]
        symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
        colored = true,
        update_in_insert = true,
        always_visible = false,
      }

      local diff = {
        "diff",
        colored = false,
        symbols = { added = "+", modified = "~", removed = "-" },
        --[[ separator = { right = "" }, ]]
        cond = conditions.hide_in_width,
      }

      local mode = {
        "mode",
        --[[ fmt = function(str) ]]
        --[[ return str:sub(1, 1) ]]
        --[[ return "-- " .. str:lower() .. " --" ]]
        --[[ end, ]]
        --[[ separator = { left = "", right = "" }, ]]
        --[[ separator = { right = "", left = "" }, ]]
        --[[ separator = { right = "" }, ]]
        padding = 1,
      }

      --[[ local filetype = { ]]
      --[[ 	"filetype", ]]
      --[[ 	-- icons_enabled = true, ]]
      --[[ 	icon_only = true, ]]
      --[[ 	-- icon = nil, ]]
      --[[ } ]]
      local filesize = {
        "filesize",
        cond = conditions.buffer_not_empty,
      }

      local branch = {
        "branch",
        --[[ icons_enabled = true, ]]
        --[[ icon = " שׂ", ]]
        --[[ icon = "", ]]
        icon = "",
        --[[ icon = "", ]]
        --[[ icon  = "", ]]
        cond = conditions.buffer_not_empty,
        --[[ separator = { right = "" }, ]]
      }

      local location = {
        "location",
        padding = 0,
        colored = true,
        --[[ separator = { left = "", right = "" }, ]]
      }

      local fileformat = {
        "fileformat",
        --[[      ]]
        symbols = {
          unix = "unix", -- README
        },
        colored = true,
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
          modified = " [+]",      -- Text to show when the file is modified.
          readonly = " [!]",      -- Text to show when the file is non-modifiable or readonly.
          unnamed = " [No Name]", -- Text to show for unnamed buffers.
        },
        --[[ separator = { left = "" }, ]]
      }

      local encoding = {
        "encoding",
        fmt = string.upper,
        --[[ separator = { right = "" }, ]]
      }

      -- cool function for progress
      --[[ local progress = function() ]]
      --[[ 	local current_line = vim.fn.line(".") ]]
      --[[ 	local total_lines = vim.fn.line("$") ]]
      --[[ 	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" } ]]
      --[[ 	local line_ratio = current_line / total_lines ]]
      --[[ 	local index = math.ceil(line_ratio * #chars) ]]
      --[[ 	return chars[index] ]]
      --[[ end ]]
      -- local spaces = function()
      -- 	--[[ return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth") ]]
      -- 	return vim.api.nvim_buf_get_option(0, "shiftwidth")
      -- end

      local windows = {
        "windows",
        mode = 0, -- 0: Shows window name
        -- 1: Shows window index
        -- 2: Shows window name + window index

        max_length = vim.o.columns * 2 / 3, -- Maximum width of windows component,
        -- it can also be a function that returns
        -- the value of `max_length` dynamically.
        filetype_names = {
          TelescopePrompt = "Telescope",
          dashboard = "Dashboard",
          packer = "Packer",
          alpha = "Alpha",
        },                                            -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )
        disabled_buftypes = { "quickfix", "prompt" }, -- Hide a window if its buffer's type is disabled
      }

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          --[[ component_separators = { left = "", right = "" }, ]]
          --[[ component_separators = { left = "│", right = "│" }, ]]
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" }, --     ▀ ▀  
          disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { branch, diff },
          lualine_c = { { navic.get_location, cond = navic.is_available } },
          lualine_x = { diagnostics },
          lualine_y = { python_venv },
          lualine_z = { fileformat, encoding, "gitsign_status" },
        },
        inactive_sections = {
          lualine_a = { filesize },
          lualine_b = {},
          lualine_c = { filename },
          lualine_x = { location },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {
          "nvim-tree",
          "quickfix",
          "toggleterm",
          "nvim-dap-ui",
        },
      })
    end
  },

  -- navic
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
        highlight = true,
        separator = " : ",
        depth_limit = 0,
        --[[ depth_limit_indicator = "..", ]]
      })
    end
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    config = function()
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
      dashboard.section.header.opts.hl = "Constant"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
      alpha.setup(dashboard.opts)
    end
  },

  -- nvim-tree (filemanager)
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
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
        respect_buf_cwd = true, --[[ popup_border_style = "rounded", ]]
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
              { key = "u",                  action = "dir_up" },
              { key = "D",                  action = "dir_down" },
              { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
              { key = "L",                  cb = tree_cb("cd") },
              { key = "h",                  cb = tree_cb("close_node") },
              { key = "v",                  cb = tree_cb("vsplit") },
              { key = "s",                  cb = tree_cb("split") },
              { key = "t",                  cb = tree_cb("tabnew") },
              { key = "i",                  cb = tree_cb("preview") },
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
    end
  },

  -- indent line
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local status_ok, indent_blankline = pcall(require, "indent_blankline")
      if not status_ok then
        return
      end

      local global = vim.g

      global.indent_blankline_buftype_exclude = {
        "terminal",
        "nofile",
        "lsp-installer",
        "lspinfo",
      }

      global.indent_blankline_filetype_exclude = {
        "alpha",
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
      }

      global.indentLine_enabled = 1
      global.indent_blankline_char = "│" -- "│" "▏" "▎" "|"
      global.indent_blankline_show_trailing_blankline_indent = false
      global.indent_blankline_show_first_indent_level = true
      global.indent_blankline_use_treesitter = true
      global.indent_blankline_show_current_context = true
      global.indent_blankline_context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "def",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      }

      vim.opt.list = true
      --[[ vim.opt.listchars:append("eol:↴") ]]
      vim.opt.listchars:append("eol:󰘌")
      --[[ vim.opt.listchars:append("eol:") ]]
      --[[ vim.opt.listchars:append("eol:ﲕ") ]]
      --[[ vim.opt.listchars:append("eol:") ]]
      --[[ vim.opt.listchars:append("eol:") ]]
      -- ﬋ ﬋
      -- 

      indent_blankline.setup({
        show_end_of_line = true,
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      })
    end
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    config = function()
      local status_ok, bufferline = pcall(require, "bufferline")
      if not status_ok then
        return
      end

      local colors = require('onedark.colors')


      bufferline.setup({
        options = {
          mode = "buffers",                    -- set to "tabs" to only show tabpages instead
          numbers = "none",                    -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
          right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
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
          fill = {
            bg = colors.bg0
          },
          tab_close = {
            fg = colors.red,
          },
          close_button = {
            fg = colors.red,
          },
          close_button_visible = {
            fg = colors.red,
          },
          close_button_selected = {
            fg = colors.red,
          },
          offset_separator = {
            fg = "#ffffff",
            bg = "#ffffff",
          },
        },
      })
    end
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end

      local actions = require("telescope.actions")
      local actions_state = require("telescope.actions.state")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              --[[ preview_width = 0.55, ]]
              --[[ results_width = 0.8, ]]
              --[[ width = 90, ]]
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          -- prompt_prefix = " ",
          selection_caret = " ",
          winblend = 0,
          prompt_prefix = "   ",
          --[[ selection_caret = "  ", ]]
          entry_prefix = "  ",
          path_display = { "smart", "shorten" },
          file_ignore_patterns = {
            "./node_modules/*",
            "node_modules",
            "^node_modules/*",
            "node_modules/*",
            "node%_modules/.*",
          },
          find_command = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          use_less = true,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          mappings = {
            i = {
                  ["<C-n>"] = actions.cycle_history_next,
                  ["<C-p>"] = actions.cycle_history_prev,
                  ["<C-j>"] = actions.move_selection_next,
                  ["<C-k>"] = actions.move_selection_previous,
                  ["<C-c>"] = actions.close,
                  ["<Down>"] = actions.move_selection_next,
                  ["<Up>"] = actions.move_selection_previous,
                  ["<CR>"] = actions.select_default,
                  ["<C-x>"] = actions.select_horizontal,
                  ["<C-v>"] = actions.select_vertical,
                  ["<C-t>"] = actions.select_tab,
                  ["<C-u>"] = actions.preview_scrolling_up,
                  ["<C-d>"] = actions.preview_scrolling_down,
                  ["<PageUp>"] = actions.results_scrolling_up,
                  ["<PageDown>"] = actions.results_scrolling_down,
                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                  ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                  ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                  ["<C-l>"] = actions.complete_tag,
              -- ["<C-h>"] = actions.which_key, -- keys from pressing <C-/>
                  ["<C-h>"] = function()
                print(vim.inspect(actions_state.get_selected_entry()))
              end, -- keys from pressing <C-/>
            },
            n = {
                  ["<esc>"] = actions.close,
                  ["<CR>"] = actions.select_default,
                  ["<C-x>"] = actions.select_horizontal,
                  ["<C-v>"] = actions.select_vertical,
                  ["<C-t>"] = actions.select_tab,
                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                  ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                  ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                  ["j"] = actions.move_selection_next,
                  ["k"] = actions.move_selection_previous,
                  ["H"] = actions.move_to_top,
                  ["M"] = actions.move_to_middle,
                  ["L"] = actions.move_to_bottom,
                  ["<Down>"] = actions.move_selection_next,
                  ["<Up>"] = actions.move_selection_previous,
                  ["gg"] = actions.move_to_top,
                  ["G"] = actions.move_to_bottom,
                  ["<C-u>"] = actions.preview_scrolling_up,
                  ["<C-d>"] = actions.preview_scrolling_down,
                  ["<PageUp>"] = actions.results_scrolling_up,
                  ["<PageDown>"] = actions.results_scrolling_down,
                  ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            path_display = { "smart" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
    end
  },

  -- which key
  {
    "folke/which-key.nvim",
    lazy = true,
    config = function()
      local status_ok, which_key = pcall(require, "which-key")
      if not status_ok then
        return
      end

      local setup = {
        plugins = {
          marks = true,       -- shows a list of your marks on ' and `
          registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          presets = {
            operators = false,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
          },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        -- key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
        -- },
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "➜", -- symbol used between a key and it's label
          group = "+",      -- symbol prepended to a group
        },
        popup_mappings = {
          scroll_down = "<c-d>", -- binding to scroll down inside the popup
          scroll_up = "<c-u>",   -- binding to scroll up inside the popup
        },
        window = {
          border = "none",          -- none, single, double, shadow
          position = "top",         -- bottom, top
          -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          -- winblend = 10,
        },
        layout = {
          height = { min = 4, max = 25 },                                             -- min and max height of the columns
          width = { min = 20, max = 50 },                                             -- min and max width of the columns
          spacing = 5,                                                                -- spacing between columns
          align = "center",                                                           -- align columns left, center or right
        },
        ignore_missing = true,                                                        -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true,                                                             -- show help message on the command line when the popup is visible
        triggers = "auto",                                                            -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for key maps that start with a native binding
          -- most people should not need to change this
          i = { "j", "k" },
          v = { "j", "k" },
        },
      }

      local opts = {
        mode = "n",     -- NORMAL mode
        prefix = "<leader>",
        buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true,  -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true,  -- use `nowait` when creating keymaps
      }

      local mappings = {
            ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
            ["b"] = {
          "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
          "Buffers", },
            ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
            ["w"] = { "<cmd>luafile %<CR>", "Lua Reload" },
            ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
            ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
            ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
            ["S"] = { "<cmd>Telescope grep_string<cr>", "Grep String" },
            ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
            ["L"] = { "<cmd>Lazy<cr>", "Lazy" },
        g = {
          name = "Git",
          g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
          j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
          l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          t = {
            name = "Toggle",
            d = { "<cmd>lua require('gitsigns').toggle_deleted()<cr>", "Toggle Show deleted" },
            l = { "<cmd>lua require('gitsigns').toggle_linehl()<cr>", "Toggle line hightlight" },
            n = { "<cmd>lua require('gitsigns').toggle_numhl()<cr>", "Toggle number hightlight" },
            s = { "<cmd>lua require('gitsigns').toggle_signs()<cr>", "Toggle sign columns hightlight" },
          },
          p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
          },
          o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
          d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
          },
        },
        l = {
          name = "LSP",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          d = {
            "<cmd>Telescope diagnostics<cr>",
            "Diagnostics",
          },
          w = {
            "<cmd>Telescope lsp_workspace_symbols<cr>",
            "Workspace Diagnostics",
          },
          f = { "<cmd>lua vim.lsp.buf.format({async=true})<cr>", "Format" },
          i = { "<cmd>LspInfo<cr>", "Info" },
          t = { "<cmd>Telescope lsp_type_definitions<cr>", "Type Definition" },
          I = { "<cmd>Mason<cr>", "Installer Info" },
          j = {
            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
          },
          k = {
            "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
          },
          l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
          q = { "<cmd>lua vim.lsp.diagnostic.setloclist()<cr>", "Quickfix" },
          r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
          s = { "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>", "Document Symbols" },
          S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
          },
        },
        s = {
          name = "Search",
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
          h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
          M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
          R = { "<cmd>Telescope registers<cr>", "Registers" },
          k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
          K = { "<cmd>checkhealth<cr>", "Check Health" },
          C = { "<cmd>Telescope commands<cr>", "Commands" },
        },
        t = {
          name = "Terminal",
          c = { "<cmd>lua _COMPEL_TOGGLE()<cr>", "Comple C++" },
          n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
          u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
          t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
          p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
          r = { "<cmd>lua _RANGER_TOGGLE()<cr>", "Ranger" },
          f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
          h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
          v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
        },
        o = {
          name = "toggler",
          a = { "<cmd>set autochdir!<cr>", "Toggle AutoChdir" },
          r = { "<cmd>lua require('rest-nvim').run()<cr>", "Rest" },
          w = { "<cmd>set wrap!<cr>", "Toggle Wrap" },
          l = { "<cmd>loadview<cr>", "Load View" },
          n = { "<cmd>setlocal number!<cr><cmd>setlocal norelativenumber!<cr>", "disable number" },
        },
        m = {
          name = "Markdown",
          n = { "<cmd>MarkdownPreview<cr>", "Markdown Preview Start" },
          s = { "<cmd>MarkdownPreviewStop<cr>", "Markdown Preview Stop" },
          t = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown Preview Toggle" },
        },
      }

      which_key.setup(setup)
      which_key.register(mappings, opts)
    end
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
        return
      end

      toggleterm.setup({
        size = 50,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float", -- Horizontal | vertical | float
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "single", -- 'single' | 'double' | 'shadow' | 'curved' |
          winblend = 0,
          --[[ highlights = { ]]
          --[[ 	border = "Normal", ]]
          --[[ 	background = "Normal", ]]
          --[[ }, ]]
        },
      })

      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float", -- Horizontal | vertical | float
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      local ranger = Terminal:new({
        cmd = "ranger",
        -- hidden = true,
        direction = "float", -- Horizontal | vertical | float
      })

      function _RANGER_TOGGLE()
        ranger:toggle()
      end

      local node = Terminal:new({ cmd = "node", hidden = true })

      function _NODE_TOGGLE()
        node:toggle()
      end

      local ncdu = Terminal:new({
        cmd = "ncdu",
        hidden = true,
        direction = "float", -- Horizontal | vertical | float
      })

      function _NCDU_TOGGLE()
        ncdu:toggle()
      end

      local htop = Terminal:new({
        cmd = "htop",
        hidden = true,
        direction = "float", -- Horizontal | vertical | float
      })

      local compel = Terminal:new({
        cmd = "compel",
        -- hidden = true,
        direction = "float", -- Horizontal | vertical | float
      })

      function _HTOP_TOGGLE()
        htop:toggle()
      end

      local python = Terminal:new({ cmd = "python3", hidden = true })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      function _COMPEL_TOGGLE()
        compel:toggle()
      end
    end
  }

}
