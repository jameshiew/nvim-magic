require('plugins')

-- highlight anything which is yanked
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]] ,
  false
)

-- whitespace
vim.cmd([[
set list lcs=trail:~,tab:»»,extends:>,precedes:<,nbsp:·
]])
vim.o.tabstop = 4
vim.o.shiftwidth = vim.o.tabstop
vim.o.breakindent = true
vim.o.viewoptions = 'folds,cursor'

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- other
vim.cmd([[filetype plugin on]])

vim.cmd([[set clipboard+=unnamedplus]])

vim.o.completeopt = 'menu,menuone,noselect'
vim.o.mouse = 'a'

vim.o.number = true
vim.o.termguicolors = true
