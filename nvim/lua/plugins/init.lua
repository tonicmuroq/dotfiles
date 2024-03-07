local fn = vim.fn

-- Automatically install packer.
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
  vim.cmd("packadd packer.nvim")
end

local packer = require("packer")

packer.startup({
  function(use)
    use("wbthomason/packer.nvim")

    -- general dependency
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("kyazdani42/nvim-web-devicons")

    -- ui enhancement
    use("stevearc/dressing.nvim")
    use("NvChad/nvim-colorizer.lua")

    -- syntax highlight
    use("lifepillar/pgsql.vim")
    use("uarun/vim-protobuf")
    use("maralla/gomod.vim")
    use("modocache/move.vim")

    -- copilot
    -- use("github/copilot.vim")
    -- use("zbirenbaum/copilot.lua")

    -- colorscheme
    use("tyrannicaltoucan/vim-deep-space")
    use({ "catppuccin/nvim", as = "catppuccin" })

    -- dependency management
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")

    -- util
    use("windwp/nvim-autopairs")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- lsp
    use("neovim/nvim-lspconfig")
    use("j-hui/fidget.nvim")

    -- lint
    use("mfussenegger/nvim-lint")

    -- formatter
    use("mhartington/formatter.nvim")

    -- completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("saadparwaiz1/cmp_luasnip")
    use("L3MON4D3/LuaSnip")
    use("lukas-reineke/cmp-under-comparator")

    -- telescope
    use("nvim-telescope/telescope.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use('LukasPietzschmann/telescope-tabs')

    -- status line
    use("vim-airline/vim-airline")
    use("vim-airline/vim-airline-themes")

    -- file explorer
    use("kyazdani42/nvim-tree.lua")

    -- test runner
    use("vim-test/vim-test")

    -- use("nathom/filetype.nvim")

    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})

require("plugins.dressing")
require("plugins.colorscheme")
-- require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.fidget")
require("plugins.formatter")
require("plugins.nvim_lint")
require("plugins.nvim_cmp")
require("plugins.telescope")
require("plugins.nvim_tree")
require("plugins.test")
require("plugins.airline")
-- require("plugins.colorize")
