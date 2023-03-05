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
