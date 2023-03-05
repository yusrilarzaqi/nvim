return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "akinsho/toggleterm.nvim",
  "lewis6991/impatient.nvim",
  { "folke/which-key.nvim", lazy = true },
  "moll/vim-bbye",

  -- LSP
  "onsails/lspkind.nvim",
  "neovim/nvim-lspconfig",
  "tamago324/nlsp-settings.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "RRethy/vim-illuminate",
  "jose-elias-alvarez/null-ls.nvim",
  { "j-hui/fidget.nvim",    opts = {} },

  -- Telescope
  { "nvim-telescope/telescope-fzf-native.nvim",       build = "make" },

  -- Git
  "lewis6991/gitsigns.nvim",

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
