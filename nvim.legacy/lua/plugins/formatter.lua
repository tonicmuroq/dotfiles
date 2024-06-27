require("formatter").setup({
  filetype = {
    python = { require("formatter.filetypes.python").black },
    yaml = { require("formatter.filetypes.yaml").prettier },
  }
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.yml", "*.yaml" },
  command = ":FormatWrite",
})
