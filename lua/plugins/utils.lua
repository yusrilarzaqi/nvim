return {
  -- rest (http requests)
  {
    "rest-nvim/rest.nvim",
    config = {
      {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to nil if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      }
    }
  },

  -- ufo (folding)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      --[[ vim.o.foldcolumn = "1" ]]
      vim.o.foldlevel = 10 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldenable = true
      vim.cmd([[
        hi default link UfoPreviewSbar PmenuSbar
        hi default link UfoPreviewThumb PmenuThumb
        hi default link UfoPreviewWinBar UfoFoldedBg
        hi default link UfoPreviewCursorLine Visual
        hi default link UfoFoldedEllipsis Comment
        hi default link UfoCursorFoldedLine CursorLine
      ]])

      require('ufo').setup({
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
          },
        },
        provider_selector = function() -- bufnr, filetype, buftype
          --[[ return { "treesitter", "indent" } ]]
          return "indent"
        end,
      })

      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- nvimlsp
          vim.lsp.buf.hover()
        end
      end)
    end
  },

  -- better escape
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mapping = { "jj", "jk" },
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false,  -- clear line after escaping if there is only whitespace
        keys = "<Esc>",             -- keys used for escaping, if it is a function will use the result everytime
      })
    end
  },

  -- auto pair
  {
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      require('cmp').event:on("confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } }))
    end
  },

  -- comment
  {
    "numToStr/Comment.nvim",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = {
      pre_hook = function(ctx)
        local U = require("Comment.utils")

        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
          location = location,
        })
      end,
    }
  },

  -- colorizer
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup({ "*" }, {
        RGB = true,          -- #RGB hex codes
        RRGGBB = true,       -- #RRGGBB hex codes
        names = true,        -- "Name" codes like Blue
        RRGGBBAA = true,     -- #RRGGBBAA hex codes
        rgb_fn = true,       -- CSS rgb() and rgba() functions
        hsl_fn = false,      -- CSS hsl() and hsla() functions
        css = true,          -- Enable all css features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "background", -- Set the display mode
      })
    end
  },

  -- project
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require('project_nvim').setup({
        active = true,
        manual_mode = false, -- false
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "bin", "README.md" },
        show_hidden = false,
        silent_chdir = true,
        ignore_lsp = {},
        datapath = vim.fn.stdpath("data"),
      })
      require('telescope').load_extension("projects")
    end
  },

  -- gitsign
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local status_ok, gitsigns = pcall(require, "gitsigns")
      if not status_ok then
        return
      end

      gitsigns.setup({
        signs = {
          -- ▎
          --[[ add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" }, ]]
          add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          --[[ delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" }, ]]
          delete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = {
            hl = "GitSignsChange",
            text = "▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = true,
        },
        current_line_blame_formatter_opts = {
          relative_time = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
      })
    end
  }
}
