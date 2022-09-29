-- Format the file before it is written
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('AutoformatOnWrite', {}),
    callback = function() vim.lsp.buf.formatting_sync(nil, 1000) end
})

-- Reload file when it has changed
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('ReloadFileOnChange', {}),
    command = 'checktime',
})
