require("mason").setup()
require("mason-lspconfig").setup({ automatic_installation = true })

local servers = {
  "bashls",
  "clangd",
  "cssls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "pyright",
  "rnix",
  "rust_analyzer",
  "lua_ls",
  "taplo",
  "tsserver",
  "yamlls",
  "move_analyzer",
}

local lspconfig = require("lspconfig")
local default_config = require("lsp.default")
for _, server in ipairs(servers) do
  local configured, config = pcall(require, "lsp.servers." .. server)
  if configured then
    lspconfig[server].setup(
      vim.tbl_deep_extend("keep", config, default_config)
    )
  end
end
