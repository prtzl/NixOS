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

-- Shit doesn't work
-- 'git-worktree' extension doesn't exist or isn't installed: module 'telescope._extensions. git-worktree' not found:
-- require("git-worktree").setup()
-- require("telescope").load_extension("git-worktree")

-- local worktree = require 'git-worktree'
-- worktree.setup()
-- telescope.load_extension('git-worktree')
