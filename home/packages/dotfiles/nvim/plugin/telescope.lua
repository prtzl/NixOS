vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = 220 })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#252a35" })

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
