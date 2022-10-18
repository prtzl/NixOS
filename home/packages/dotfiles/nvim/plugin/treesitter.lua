-- Enable treesitter: format and color all the source files!
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = function(lang, bufnr) -- Disable in large buffers
            return vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}
