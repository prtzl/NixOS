local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "┬──┬ ノ( ゜-゜ノ)",
}

-- Set menu TODO: make sense of the buttons, fine for now since I don't use them
dashboard.section.buttons.val = {
    -- dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    -- dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
    -- dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    -- dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    -- dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

-- Set footer
dashboard.section.footer.val = {
    "(ノಠ 益ಠ)ノ彡┻━┻",
}


-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
