vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.toml" },
  callback = function() vim.lsp.buf.format() end,
})

return {}
