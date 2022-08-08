vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.toml" },
  callback = function() vim.lsp.buf.formatting_sync(nil, 500) end,
})

return {}
