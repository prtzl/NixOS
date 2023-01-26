vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = 220 })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#252a35" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#123456", fg = "#ffffff" })

local telescope = require 'telescope'
local actions = require 'telescope.actions'

telescope.setup {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = { width = 0.99, prompt_position = 'top' },
        sorting_strategy = 'ascending',
        scroll_strategy = 'limit',
        border = true,
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<c-u>"] = false,
            }
        }
    },
}
