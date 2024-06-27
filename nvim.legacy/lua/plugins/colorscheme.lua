require('kanagawa').setup({
  compile = false,  -- enable compiling the colorscheme
  undercurl = true, -- enable undercurls
  commentStyle = { italic = false },
  functionStyle = {},
  keywordStyle = { italic = false },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = false,   -- do not set background color
  dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
  terminalColors = true, -- define vim.g.terminal_color_{0,17}
  colors = {             -- add/modify theme and palette colors
    palette = {
      peachRed = "#E46876",
    },
    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  },
  overrides = function(colors) -- add/modify highlights
    return {
      ["@string.special.url"] = { fg = colors.theme.syn.special1, undercurl = false },
      ["@variable.builtin"] = { fg = colors.theme.syn.special2, italic = false },
    }
  end,
  background = {   -- map the value of 'background' option to a theme
    dark = "wave", -- try "dragon" !
    light = "lotus"
  },
})
vim.cmd("colorscheme kanagawa")


-- vim.cmd("colorscheme tokyonight-moon")


-- vim.cmd("colorscheme nordic")


-- vim.cmd("colorscheme deep-space")
-- local function hl(group, opts)
--   vim.api.nvim_set_hl(0, group, opts)
-- end

-- hl("VirtualTextError", { ctermfg = 167, fg = "#c14a4a" })
-- hl("VirtualTextWarning", { ctermfg = 214, fg = "#b47109" })
-- hl("VirtualTextInfo", { ctermfg = 109, fg = "#45707a" })
-- hl("VirtualTextHint", { ctermfg = 142, fg = "#6c782e" })
-- hl("TSField", { link = "Fg" })
-- hl("TSNamespace", { link = "Fg" })
-- hl("NvimTreeFolderIcon", { link = "Blue" })
-- hl("FidgetTask", { link = "Comment" })
-- hl("Search", { ctermfg = 235, ctermbg = 167, fg = "#282828", bg = "#ea6962" })
-- hl('Identifier', { fg = '#9aa7bd' })


-- vim.cmd("colorscheme catppuccin")
-- require("catppuccin").setup({
--   flavour = "macchiato", -- latte, frappe, macchiato, mocha
--   -- color_overrides = {
--   --   all = {
--   --     base = '#1b202a',
--   --   }
--   -- },
-- })
