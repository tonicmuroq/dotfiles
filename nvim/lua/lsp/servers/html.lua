vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.html" },
  callback = function() vim.lsp.buf.format() end,
})

return {}
