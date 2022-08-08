local telescope = require("telescope")

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.load_extension("fzf")

local function map(keys, cmd)
  vim.keymap.set("n", keys, cmd, { noremap = true, silent = true })
end

map("<leader>f", builtin.find_files)
map("<leader>o", builtin.oldfiles)
map("<leader>b", builtin.buffers)
map("<leader>/", builtin.live_grep)

local function lsp_goto_picker(theme)
  return {
    theme = theme,
    initial_mode = "normal",
    path_display = { "smart" },
    mappings = {
      n = {
        ["o"] = actions.select_default,
        ["q"] = actions.close,
      },
    },
  }
end

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
      },
    },
  },
  pickers = {
    lsp_definitions = lsp_goto_picker("ivy"),
    lsp_declarations = lsp_goto_picker("ivy"),
    lsp_type_definitions = lsp_goto_picker("ivy"),
    lsp_references = lsp_goto_picker("ivy"),
    lsp_implementations = lsp_goto_picker("ivy"),
    diagnostics = lsp_goto_picker("ivy"),
  },
})
