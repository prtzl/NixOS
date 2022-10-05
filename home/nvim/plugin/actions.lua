-- Format the file before it is written

local formatToggle = function()
    if vim.g.formatToggle then
        vim.lsp.buf.formatting()
    end
end

vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('OnWrite', {}),
    callback = formatToggle
})

-- Reload file when it has changed
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('ReloadFileOnChange', {}),
    command = 'checktime',
})

-- Current format state, enabled on start
vim.g.formatToggle = true
function vim.g.toggleFormat()
    local tog = vim.g.formatToggle
    if tog then
        vim.g.formatToggle = false
        print("Format disabled!")
    else
        vim.g.formatToggle = true
        print("Format enabled!")
    end
end
