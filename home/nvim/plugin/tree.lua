-- I don't know why this is here
require 'nvim-tree'.setup {
    open_on_setup = false,
    open_on_setup_file = false,
    open_on_tab = false,
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    renderer = {
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " → ",
            show = {
                file = true,
                folder = true,
                folder_arrow = false,
                git = true,
            },
        },
    },
    filesystem_watchers = {
        enable = true,
    },
}

-- Automatically close the tab/vim when nvim-tree is the last window in the tab
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('CloseNvimTreeWhenLast', {}),
    command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
    nested = true,
})
