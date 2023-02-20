require("options")
require("keymaps")
require("plugins")
require("lsp")
require("autocmd")


require('filetype').setup({
  extensions = {
    move = 'move',
  }
})
