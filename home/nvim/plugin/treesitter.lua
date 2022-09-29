-- Enable treesitter: format and color all the source files!
require'nvim-treesitter.configs'.setup{
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
}
