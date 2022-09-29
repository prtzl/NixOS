-- Keymaps
function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Window movement in insert mode
map('i', '<c-w><left>', '<esc><right><c-w><left><ins>', nil)
map('i', '<c-w><right>', '<esc><right><c-w><right><ins>', nil)
map('i', '<c-w><up>', '<esc><right><c-w><up><ins>', nil)
map('i', '<c-w><down>', '<esc><right><c-w><down><ins>', nil)

-- backspace delete
map('!', '<c-bs>', '<c-w>', nil)
map('!', '<c-h>', '<c-w>', nil)

-- Move back and forth in buffers
map('n', '<c-[>', ':bprev<cr>', nil)
map('n', '<c-]>', ':bnext<cr>', nil)

-- LSP
map('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', nil)
map('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<cr> ', nil)
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>      ', nil)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', nil)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr> ', nil)

-- Snippets - move between fields
map('i', '<c-j>', '<cmd>lua require"luasnip".jump(1)<CR>', nil)
map('s', '<c-j>', '<cmd>lua require"luasnip".jump(1)<CR>', nil)
map('i', '<c-k>', '<cmd>lua require"luasnip".jump(-1)<CR>', nil)
map('s', '<c-k>', '<cmd>lua require"luasnip".jump(-1)<CR>', nil)

-- FZF
map('n', '<c-p>', ':Files<cr>', {silent=false})
map('n', '<c-g>', ':Rg<cr>', {silent=false})
map('n', '<c-f>', ':BLines<cr>', {silent=false})
map('n', '<c-b>', ':Buffers<cr>', {silent=false})

-- Diagnostic
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<cr>', nil)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', nil)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', nil)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', nil)

-- Spell toggle
map('n', '<f6>', ':set spell!<cr>', nil)
