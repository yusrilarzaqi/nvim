function P(data)
  print(vim.inspect(data))
end

-- vim.cmd([[hi NvimTreeWindowPicker guibg=#ffffff]])

-- #41a7fc
local function Colors(color)
  color = color or "onedark"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

Colors()
