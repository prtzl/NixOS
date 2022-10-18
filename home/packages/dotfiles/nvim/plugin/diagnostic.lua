-- Diagnostic signs
local signs = {
    { name = 'DiagnosticSignError', text = '🔥' },
    { name = 'DiagnosticSignWarn', text = '!' },
    { name = 'DiagnosticSignHint', text = '💡' },
    { name = 'DiagnosticSignInfo', text = '🔸' },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.diagnostic.config {
    virtual_text = true,
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
        scope = 'line',
    },
}
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
