return {
  -- cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
    },
    event = "InsertEnter",
    config = function()
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end

      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end

      require("luasnip/loaders/from_vscode").lazy_load()

      local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end

      local lspkind_status_ok, lspkind = pcall(require, "lspkind")
      if not lspkind_status_ok then
        return
      end

      --   פּ ﯟ   some other good icons
      local kind_icons = {
        Text = "",
        Method = "m",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }
      -- find more here: https://www.nerdfonts.com/cheat-sheet
      --[[ local border = { "🭽", " ", "🭾", "▕", "🭿", " ", "🭼", "▏" } ]]
      --[[ local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } ]]
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = {
              ["<C-k>"] = cmp.mapping.select_prev_item(),
              ["<C-j>"] = cmp.mapping.select_next_item(),
              ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
              ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
              ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
              ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
              ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format({
                  mode = "symbol_text",
                  menu = {
                    buffer = "Buffer",
                    nvim_lsp = "LSP",
                    luasnip = "Snip",
                    nvim_lua = "Lua",
                    latex_symbols = "Latex",
                    cmp_tabnine = "TabNine",
                  },
                  maxwidth = 50,
                })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            -- kind.menu = strings[2]

            return kind
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "cmp_tabnine" },
          { name = "luasnip" },
          {
            name = "buffer",
            option = {
              get_bufrnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
          { name = "path" },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          documentation = {
            --[[ border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, ]]
            border = border,
          },
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
          },
        },
        experimental = {
          ghost_text = true,
          native_menu = false,
        },
      })

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        autotag = {
          enable = true,
        },
        ensure_installed = { "lua", "python", "javascript", "html", "css", "java", "c", "cpp", "help", "vim" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = false,                                                                          -- install languages synchronously (only applied to `ensure_installed`)
        -- ignore_install = { "" }, -- List of parsers to ignore installing
        autopairs = {
          enable = true,
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          -- disable = { "" }, -- list of language that will be disabled
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        rainbow = {
          enable = true,
          extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobject = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
                  ["aa"] = "@parameter.outer",
                  ["ia"] = "@parameter.inner",
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["ac"] = "@class.outer",
                  ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                  ["]m"] = "@function.outer",
                  ["]]"] = "@class.outer",
            },
            goto_next_end = {
                  ["]M"] = "@function.outer",
                  ["]["] = "@class.outer",
            },
            goto_previous_start = {
                  ["[m"] = "@function.outer",
                  ["[["] = "@class.outer",
            },
            goto_previous_end = {
                  ["[M"] = "@function.outer",
                  ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
                  ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                  ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end
  },

  -- sinppets
  {"L3MON4D3/LuaSnip"},
  {"rafamadriz/friendly-snippets"},

}
