return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require('nvim-web-devicons').setup({
        default = true,
      })
    end
  },
  {
    "lewis6991/impatient.nvim",
    config = function()
      local status_ok, impatient = pcall(require, "impatient")
      if not status_ok then
        return
      end

      impatient.enable_profile()
    end
  },
  "moll/vim-bbye",

  -- LSP
  "onsails/lspkind.nvim",
  "neovim/nvim-lspconfig",
  "tamago324/nlsp-settings.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "RRethy/vim-illuminate",
  "jose-elias-alvarez/null-ls.nvim",
  { "j-hui/fidget.nvim",                              opts = {} },

  -- Telescope
  { "nvim-telescope/telescope-fzf-native.nvim",       build = "make" },

  -- react
  { "dsznajder/vscode-es7-javascript-react-snippets", build = "yarn install --frozen-lockfile && yarn compile" },

  -- auto closing tag
  "windwp/nvim-ts-autotag",

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  "dstein64/vim-startuptime",
  "nikvdp/ejs-syntax",
}
