vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.rs" },
  callback = function() vim.lsp.buf.formatting_sync(nil, 500) end,
})

return {
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "crate",
          enforce = true,
        },
      },
      checkOnSave = {
        command = "clippy",
      },
      completion = {
        callable = {
          snippets = "add_parentheses",
        },
        postfix = {
          enable = false,
        },
      },
      workspace = {
        symbol = {
          search = {
            kind = "all_symbols",
          },
        },
      },
    },
  },
}
