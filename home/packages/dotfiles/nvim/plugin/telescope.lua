vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = 220 })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#252a35" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#123456", fg = "#ffffff" })

vim.set_global("telescope_disable_completion", 1)

require('telescope').setup {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = { width = 0.99, prompt_position = 'top' },
        sorting_strategy = 'ascending',
        scroll_strategy = 'limit',
        border = true,
        path_display = 'absolute'
    },
}
