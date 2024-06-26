vim.g.mapleader = "\\"

local options = {
  fileencoding = "UTF-8",
  swapfile = false,
  backup = false,
  writebackup = false, -- if a file is being edited by another program, it is not allowed to be edited
  updatetime = 300, -- faster completion (4000ms default)

  background = "dark",

  number = true,
  cursorline = true,

  hlsearch = true,
  incsearch = true,
  smartcase = true,
  mouse = "", -- disable stupid mouse

  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  pumheight = 10, -- pop up menu height

  autoindent = true,
  smartindent = true,
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 4, -- the number of spaces inserted for each indentation
  softtabstop = 4, -- insert 4 spaces for a tab
  tabstop = 4, -- insert 4 spaces for a tab

  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window

  termguicolors = true, -- set term gui colors (most terminals support this)

  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)

  list = true,
  listchars = {
    nbsp = "+",
    tab = "  ",
    trail = "-",
  },

  relativenumber = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
