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
  }
}
