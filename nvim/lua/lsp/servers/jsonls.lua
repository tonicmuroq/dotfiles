vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.json" },
  callback = function() vim.lsp.buf.format() end,
})

return {}
