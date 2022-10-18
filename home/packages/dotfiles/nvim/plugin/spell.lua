-- Spell check setup - default off, use :set spell to turn on
vim.opt.spell = false
vim.opt.spelllang = { 'en_us' }

vim.g.toggleSpell = function()
    local isEnabled = vim.opt.spell:get()
    if isEnabled then
        vim.opt.spell = false
        print("Spell disabled!")
    else
        vim.opt.spell = true
        print("Spell enabled!")
    end
end
