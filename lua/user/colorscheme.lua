-- kanagawa
require("kanagawa").setup({
  undercurl = true, -- enable undercurls
  commentStyle = { italic = true },
  functionStyle = { italic = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  variablebuiltinStyle = { italic = true },
  specialReturn = true,    -- special highlight for the return keyword
  specialException = true, -- special highlight for exception handling keywords
  transparent = true,      -- do not set background color
  dimInactive = true,      -- dim inactive window `:h hl-NormalNC`
  globalStatus = true,     -- adjust window separators highlight for laststatus=3
  terminalColors = true,   -- define vim.g.terminal_color_{0,17}
  colors = {
    palette = {
      sumiInk1 = "#1f1f28",
      bg = "#181820",
    }
  },
})

local onedark_status_ok, onedark = pcall(require, "onedark")
if not onedark_status_ok then
  return
end

onedark.setup({
  style = "deep",
  transparent = false,
  term_colors = true, -- Change terminal color as per the selected theme style
  ending_tildes = true,
  -- toggle theme style ---
  toggle_style_key = "<leader>ts",                                                     -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
  code_style = {
    comments = "italic",
    keywords = "italic",
    functions = "italic",
    strings = "none",
    variables = "none",
  },
  diagnostics = {
    darker = false,    -- darker colors for diagnostic
    undercurl = true,  -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
  lualine = {
    transparent = true, -- lualine center bar transparency
  },
  colors = {},          -- Override default colors
  highlights = {
    CursorColumn = { bg = "$bg2" },
    CursorLine = { bg = "$bg2" },
    ColorColumn = { bg = "$bg2" },
    CursorLineNr = { fg = "$green" },
    CmpItemMenu = { fg = "$grey" },
    PmenuSel = { bg = "#282C34", fg = "NONE" },
    Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
    CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", fmt = "strikethrough" },
    CmpItemAbbrMatch = { fg = "$bg_blue", bg = "NONE", fmt = "bold" },
    CmpItemAbbrMatchFuzzy = { fg = "$bg_blue", bg = "NONE", fmt = "bold" },
    CmpItemKindField = { fg = "$bg0", bg = "$red" },
    CmpItemKindProperty = { fg = "$bg0", bg = "$red" },
    CmpItemKindEvent = { fg = "$bg0", bg = "$red" },
    CmpItemKindText = { fg = "$bg0", bg = "#9FBD73" },
    CmpItemKindEnum = { fg = "$bg0", bg = "#9FBD73" },
    CmpItemKindKeyword = { fg = "$bg0", bg = "#9FBD73" },
    CmpItemKindConstant = { fg = "$bg0", bg = "$bg_yellow" },
    CmpItemKindConstructor = { fg = "$bg0", bg = "$bg_yellow" },
    CmpItemKindReference = { fg = "$bg0", bg = "$bg_yellow" },
    CmpItemKindFunction = { fg = "$bg0", bg = "$blue" },
    CmpItemKindStruct = { fg = "$bg0", bg = "$purple" },
    CmpItemKindClass = { fg = "$bg0", bg = "$purple" },
    CmpItemKindModule = { fg = "$bg0", bg = "$purple" },
    CmpItemKindOperator = { fg = "$bg0", bg = "$purple" },
    CmpItemKindVariable = { fg = "$bg0", bg = "#7E8294" },
    CmpItemKindFile = { fg = "$bg0", bg = "#7E8294" },
    CmpItemKindUnit = { fg = "$bg0", bg = "#D4A959" },
    CmpItemKindSnippet = { fg = "$bg0", bg = "#D4A959" },
    CmpItemKindFolder = { fg = "$bg0", bg = "#D4A959" },
    CmpItemKindMethod = { fg = "$bg0", bg = "$bg_blue" },
    CmpItemKindValue = { fg = "$bg0", bg = "$bg_blue" },
    CmpItemKindEnumMember = { fg = "$bg0", bg = "$bg_blue" },
    CmpItemKindInterface = { fg = "$bg0", bg = "#58B5A8" },
    CmpItemKindColor = { fg = "$bg0", bg = "#58B5A8" },
    CmpItemKindTypeParameter = { fg = "$bg0", bg = "#58B5A8" },
    TelescopePromptTitle = { bg = "$red", fg = "$bg0" },
    TelescopePromptBorder = { bg = "$bg0", fg = "$bg0" },
    TelescopePromptNormal = { bg = "$bg0", fg = "$fg" },
    TelescopeResultsTitle = { bg = "$bg_blue", fg = "$bg0" },
    TelescopeResultsBorder = { bg = "$bg0", fg = "$bg0" },
    TelescopePreviewTitle = { bg = "$green", fg = "$bg0" },
    TelescopePreviewBorder = { bg = "$bg0", fg = "$bg0" },
    TelescopeSelection = { fmt = 'bold' },
    TelescopeBorder = { bg = "$fg", fg = "$bg0" },
  },
})

onedark.load()
