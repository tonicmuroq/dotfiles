local function map(keys, cmd)
  vim.keymap.set("n", keys, cmd, { noremap = true, silent = true })
end

vim.g["test#strategy"] = "neovim"

vim.g["test#go#runner"] = "gotest"
vim.g["test#go#gotest#options"] = "-v -race -failfast --count=1"

vim.g["test#rust#runner"] = "cargotest"
vim.g["test#rust#cargotest#options"] = "-- --nocapture"

map("<leader>tn", "<cmd>TestNearest<CR>")
map("<leader>tf", "<cmd>TestFile<CR>")
map("<leader>tl", "<cmd>TestLast<CR>")
map("<leader>tv", "<cmd>TestVisit<CR>")
