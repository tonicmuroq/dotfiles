require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  color_overrides = {
    all = {
      base = '#1b202a',
    }
  },
})

vim.cmd("colorscheme deep-space")
-- vim.cmd("colorscheme catppuccin")

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- hl("VirtualTextError", { ctermfg = 167, fg = "#c14a4a" })
-- hl("VirtualTextWarning", { ctermfg = 214, fg = "#b47109" })
-- hl("VirtualTextInfo", { ctermfg = 109, fg = "#45707a" })
-- hl("VirtualTextHint", { ctermfg = 142, fg = "#6c782e" })
-- hl("TSField", { link = "Fg" })
-- hl("TSNamespace", { link = "Fg" })
-- hl("NvimTreeFolderIcon", { link = "Blue" })
-- hl("FidgetTask", { link = "Comment" })
-- hl("Search", { ctermfg = 235, ctermbg = 167, fg = "#282828", bg = "#ea6962" })
hl('Identifier', { fg = '#9aa7bd' })
