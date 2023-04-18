vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function() vim.lsp.buf.format() end,
})

return {}
