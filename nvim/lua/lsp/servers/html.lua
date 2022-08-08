vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.html" },
  callback = function() vim.lsp.buf.formatting_sync(nil, 500) end,
})

return {}
