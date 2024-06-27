local dressing = require("dressing")
local telescope = require("telescope.themes").get_cursor({
  initial_mode = "normal",
})

dressing.setup({
  select = {
    telescope = telescope
  },
})
