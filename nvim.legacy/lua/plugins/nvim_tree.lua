local function map(mod, keys, cmd)
  vim.keymap.set(mod, keys, cmd, { noremap = true, silent = true })
end

map("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>")
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>")

require("nvim-tree").setup({
  update_cwd = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  system_open = {
    cmd = "code",
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = false,
      },
    },
  },
})
