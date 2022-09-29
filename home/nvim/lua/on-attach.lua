function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- map: ''
-- map!: '!'
-- nmap: 'n'
-- imap: 'i'
-- vmap: 'v'
-- noremap -> option
-- Example: nnoremap = 'n', opts = { noremap = true }
-- Example noremap! = '!', opts = { noremap = true }

local function on_attach(client, buffer)
	require 'lsp_signature'.on_attach {}

    -- Window movement in insert mode
    map('i', '<c-w><left>', '<esc><right><c-w><left><ins>', {silent=true})
    map('i', '<c-w><right>', '<esc><right><c-w><right><ins>', {silent=true})
    map('i', '<c-w><up>', '<esc><right><c-w><up><ins>', {silent=true})
    map('i', '<c-w><down>', '<esc><right><c-w><down><ins>', {silent=true})

    -- backspace delete
    map('!', '<c-bs>', '<c-w>', nil)
    map('!', '<c-h>', '<c-w>', nil)

    -- Move back and forth in buffers
    --nnoremap <C-[> :bprev<cr>
    --nnoremap <C-]> :bnext<cr>
    map('n', '<c-[>', ':bprev<cr>', nil)
    map('n', '<c-]>', ':bnext<cr>', nil)

    -- LSP
    map('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', {silent=true})
    map('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<cr> ', {silent=true})
    map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>      ', {silent=true})
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {silent=true})
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr> ', {silent=true})

    -- Snippets
    -- imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    --inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
    --snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    --snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
    --imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    --smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    --map('i', '<expr>', '<tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'', opt)
    

    --nnoremap <C-p> :Files<CR>
    --nnoremap <C-g> :Rg<CR>
    --nnoremap <C-f> :BLines<CR>
    map('n', '<c-p>', ':Files<cr>', {silent=true})
    map('n', '<c-g>', ':Rg<cr>', {silent=true})
    map('n', '', '', opts)
    map('n', '', '', opts)
    map('n', '', '', opts)
    map('n', '', '', opts)
    map('n', '', '', opts)
    map('n', '', '', opts)
    map('n', '', '', opts)


	--map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	--map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	--map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	--map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

	--vim.api.nvim_buf_set_keymap(buffer, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(buffer, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

return on_attach
