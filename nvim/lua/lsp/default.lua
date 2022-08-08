local function on_attach(_, bufnr)
  local telescope = require("telescope.builtin")
  local function map(mode, key, cmd, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, key, cmd, opts)
  end

  map("n", "gd", telescope.lsp_definitions)
  map("n", "gD", vim.lsp.buf.declaration)
  map("n", "gt", telescope.lsp_type_definitions)
  map("n", "gr", function() telescope.lsp_references({ include_current_line = true }) end)
  map("n", "gi", telescope.lsp_implementations)
  map("n", "<leader>a", vim.lsp.buf.code_action)
  map("n", "<leader>s", telescope.lsp_document_symbols)
  map("n", "<leader>w", telescope.lsp_dynamic_workspace_symbols)
  map("n", "<leader>d", telescope.diagnostics)
  map("n", "K", vim.lsp.buf.hover)
  map("i", "<C-k>", vim.lsp.buf.signature_help)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "gp", vim.diagnostic.goto_prev)
  map("n", "gn", vim.diagnostic.goto_next)
  map("n", "gl", vim.diagnostic.open_float)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
