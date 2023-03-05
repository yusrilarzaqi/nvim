local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use("wbthomason/packer.nvim")       -- Have packer manage itself
  use("nvim-lua/popup.nvim")          -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim")        -- Useful lua functions used ny lots of plugins
  use("windwp/nvim-autopairs")        -- Autopairs, integrates with both cmp and treesitter
  use("numToStr/Comment.nvim")        -- Easily comment stuff
  use("kyazdani42/nvim-web-devicons") -- nerdfont
  use("kyazdani42/nvim-tree.lua")     -- optional, updated every week. (see issue #1193) -- filemanager
  use({ "akinsho/bufferline.nvim", tag = "v3.*" })
  use("nvim-lualine/lualine.nvim")
  use("akinsho/toggleterm.nvim")
  use("ahmedkhalf/project.nvim")
  use("lewis6991/impatient.nvim")
  use("lukas-reineke/indent-blankline.nvim")
  use("goolord/alpha-nvim")
  use("folke/which-key.nvim")
  use("moll/vim-bbye")
  -- use("rcarriga/nvim-notify") -- notify

  use("max397574/better-escape.nvim") -- better escape

  -- use("MunifTanjim/nui.nvim") -- ui
  --[[ use("stevearc/dressing.nvim") ]]
  -- Colorschemes
  --[[ use("lunarvim/colorschemes") -- A bunch of colorschemes you can try out ]]
  use("lunarvim/darkplus.nvim")
  use("navarasu/onedark.nvim")
  use("sainnhe/gruvbox-material")
  use("rebelot/kanagawa.nvim")
  use("Shatur/neovim-ayu")
  use('catppuccin/nvim')

  -- cmp plugins
  use("hrsh7th/nvim-cmp")    -- The completion plugin
  use("hrsh7th/cmp-buffer")  -- buffer completions
  use("hrsh7th/cmp-path")    -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  --[[ use({ "tzachar/cmp-tabnine", run = "./install.sh" }) ]]
  -- css colors
  use("norcalli/nvim-colorizer.lua")

  -- snippets
  use("L3MON4D3/LuaSnip")             --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("onsails/lspkind.nvim")
  use("neovim/nvim-lspconfig")        -- enable LSP
  use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("RRethy/vim-illuminate")
  use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
  use({ "j-hui/fidget.nvim", opts = {} })

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- Git
  use("lewis6991/gitsigns.nvim")

  -- GPS
  use("SmiteshP/nvim-navic")

  -- react
  use({ "dsznajder/vscode-es7-javascript-react-snippets", run = "yarn install --frozen-lockfile && yarn compile" })

  -- folding
  use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

  -- http client
  use("rest-nvim/rest.nvim")

  -- debuging
  --[[ use("mfussenegger/nvim-dap") ]]
  --[[ use("rcarriga/nvim-dap-ui") ]]
  --[[ use("leoluz/nvim-dap-go") ]]
  --[[ use("theHamsta/nvim-dap-virtual-text") ]]
  --[[ use("nvim-telescope/telescope-dap.nvim") ]]
  --[[ use("mfussenegger/nvim-dap-python") ]]
  -- auto closing tag
  use("windwp/nvim-ts-autotag")

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  }) -- markdown

  -- DSL
  --[[ use("elkowar/yuck.vim") -- yuck ]]
  --[[ use("gpanders/nvim-parinfer") ]]
  -- Scroll
  --[[ use("karb94/neoscroll.nvim") ]]
  -- startuptime
  use("dstein64/vim-startuptime")

  -- oether
  use("nikvdp/ejs-syntax") -- ejs

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
