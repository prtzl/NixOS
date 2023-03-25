-- This shit has to be set so that the completion menu (possibly more) is colored
vim.cmd 'set termguicolors'

require('base16-colorscheme').setup({
    -- based on ayu-dark
    base00 = '#000000', base01 = '#131721', base02 = '#272d38', base03 = '#3e4b59',
    base04 = '#bfbdb6', base05 = '#e6e1cf', base06 = '#e6e1cf', base07 = '#f3f4f5',
    base08 = '#f07178', base09 = '#ff8f40', base0A = '#ffb454', base0B = '#b8cc52',
    base0C = '#95e6cb', base0D = '#59c2ff', base0E = '#d2a6ff', base0F = '#e6b673'
})
vim.cmd 'set background=dark'

-- Overrides
vim.api.nvim_set_hl(0, "CmpItemAbbr", { cternbg = None, bg = None })
