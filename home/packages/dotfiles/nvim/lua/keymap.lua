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

map('n', '<s-up>', ':move-2<cr>', nil)
map('n', '<s-down>', ':move+1<cr>', nil)
map('i', '<s-up>', '<esc>:move-2<cr><ins><right>', nil)
map('i', '<s-down>', '<esc>:move+1<cr><ins><right>', nil)

-- Resizing windows
map('n', '<c-s-up>', ':resize +5<cr>', nil)
map('n', '<c-s-down>', ':resize -5<cr>', nil)
map('n', '<c-s-left>', ':vertical resize -5<cr>', nil)
map('n', '<c-s-right>', ':vertical resize +5<cr>', nil)

-- backspace delete
map('!', '<c-bs>', '<c-w>', nil)
map('!', '<c-h>', '<c-w>', nil)

-- move to the end of line while in insert mode
map('i', '<c-]>', '<esc>A', nil)

-- Move back and forth in buffers
-- Note so self: <c-[> is maped as if <Esc> is pressed - higher power control, abandon hope
map('n', '[[', ':bnext<cr>', nil)
map('n', ']]', ':bprev<cr>', nil)

-- LSP
map('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', nil)
map('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<cr> ', nil)
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', nil)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', nil)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr> ', nil)
map('n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { silent = false })
map('n', '<f8>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = false })

-- Snippets - move between fields
map('i', '<c-j>', '<cmd>lua require"luasnip".jump(1)<CR>', nil)
map('s', '<c-j>', '<cmd>lua require"luasnip".jump(1)<CR>', nil)
map('i', '<c-k>', '<cmd>lua require"luasnip".jump(-1)<CR>', nil)
map('s', '<c-k>', '<cmd>lua require"luasnip".jump(-1)<CR>', nil)

-- FZF
map('n', '<c-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>', nil)
map('n', '<c-a>',
    '<cmd>lua require("telescope.builtin").find_files({no_ignore = true, no_ignore_parent = true, hidden = true})<cr>',
    nil)
map('n', '<c-g>', '<cmd>lua require("telescope.builtin").live_grep()<cr>', nil)
map('n', '<c-b>', '<cmd>lua require("telescope.builtin").buffers()<cr>', nil)
map('n', '<c-f>', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', nil)

-- Diagnostic
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<cr>', nil)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', nil)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', nil)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', nil)

-- Spell toggle
map('n', '<f3>', '<cmd>lua vim.g.toggleSpell()<cr>', nil)
map('i', '<f3>', '<cmd>lua vim.g.toggleSpell()<cr>', nil)

-- Autoformat toggle
map('n', '<f4>', '<cmd>lua vim.g.toggleFormat()<cr>', nil)
map('i', '<f4>', '<cmd>lua vim.g.toggleFormat()<cr>', nil)

-- Comments
map('n', '<c-_>', 'gcc', { noremap = false })
map('v', '<c-_>', 'gcc', { noremap = false })
map('i', '<c-_>', '<esc>gcc<right>i', { noremap = false })

-- Git - lazygit
map('n', '<c-\\>', ':LazyGit<cr>', nil)

-- nvim tree view
map('n', '<c-t>', ':NvimTreeToggle<cr>', nil)
