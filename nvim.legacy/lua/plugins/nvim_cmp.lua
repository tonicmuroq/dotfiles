local cmp = require("cmp")
local luasnip = require("luasnip")
local compare = require("cmp.config.compare")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.choice_active() then
        luasnip.change_choice(-1)
      end
    end, { "i", "s" }),
  },
  completion = {
    completeopt = "menuone,noinsert", -- always select the first item
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer",                 keyword_length = 4 },
    { name = "luasnip" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
  },
  confirm_opts = { behavior = cmp.ConfirmBehavior.Replace },
  sorting = {
    comparators = {
      compare.score,
      require "cmp-under-comparator".under,
      compare.recently_used,
    },
  },
})
