require("nvim-treesitter.configs").setup({
  ensure_installed = { "comment" },
  auto_install = true,
  sync_install = false,
  highlight = {
    enable = true,
    -- disable = { "python" },
  },
})
