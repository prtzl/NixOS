-- Enable treesitter: format and color all the source files!
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = function(lang, bufnr) -- Disable in large buffers
            return vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
        additional_vim_regex_highlighting = false,
    },
}
