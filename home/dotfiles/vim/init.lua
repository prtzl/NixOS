require'impatient'

require'nvim-autopairs'.setup {}

require'fidget'.setup {}

require'gitsigns'.setup{
    signs = {
        add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '−', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '−', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '≃', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    numhl = true,
}

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

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require 'cmp'

local luasnip = require 'luasnip'

-- Use it to format completion menu, comes with default icons as well
local lspkind  = require 'lspkind'

-- some other good icons
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
    -- Disable completion on comments
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
    end,

    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = ({
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-n>'] = cmp.config.disable,
        ['<C-p>'] = cmp.config.disable,
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ['<C-k>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    }),

    -- Installed sources
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lua' },
        { name = 'texlab' },
        { name = 'spell' },
        { name = 'omni' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'treesitter' },
        { name = 'pylsp' },
    },

    -- Show: abbreviation, symbol + kind, menu
    -- In other words: short completion stirng, completion type icon and stirng, source of completion
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format {
          mode = "text_symbol",
          maxwidth = 70,
            before = function(entry, vim_item)
            local shorten_abbr = string.sub(vim_item.abbr, 1, 30)
            if shorten_abbr ~= vim_item.abbr then vim_item.abbr = shorten_abbr .. "..." end
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              buffer = "[BUF]",
              nvim_lsp = "[LSP]",
              luasnip = "[SNP]",
              nvim_lua = "[API]",
              latex_symbols = "[LTX]",
              path = "[PTH]",
              spell = "[SPL]",
              omni = "[OMN]",
              treesitter = "[TRS]"
            })[entry.source.name] or "???"
            return vim_item
          end,
        },
    },

    window = {
        documentation = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },

    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline(':', {
    sources = {
        { name = 'cmdline' }
    }
})

cmp.setup.cmdline('/', {
    sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' }
    }, {
        { name = 'buffer' }
    })
})


-- LSP servers
-- This shit is added to every server and it made it so
-- when you accept a suggestion like a function, it fills the signature and enters - finally
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- C/C++ LSP
require'lspconfig'.clangd.setup{
    capabilities = capabilities,
    cmd = {
        'clangd',
        '--background-index',
        '--inlay-hints',
        '--clang-tidy',
        '--compile-commands-dir=build',
    },
}

-- Nix LSP
require'lspconfig'.rnix.setup{
    capabilities = capabilities,
}

-- latex lsp
require'lspconfig'.texlab.setup{
    capabilities = capabilities,
}

-- Python LSP
require'lspconfig'.pylsp.setup{
    capabilities = capabilities,
}

-- lsp signature
require "lsp_signature".setup({
    hint_enable = false;
    toggle_key = '<C-s>',
    select_signature_key = '<C-l>'
})

-- This shit has to be set so that the completion menu (possibly more) is colored
vim.cmd 'set termguicolors'
-- Completion menu highlights
--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
    " gray
    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " blue
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    " light blue
    highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
    " pink
    highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    " front
    highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])


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
    -- show signs
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
    },
}


-- I don't know why this is here
require 'nvim-tree'.setup {
    open_on_setup = false,
    open_on_setup_file = false,
    open_on_tab = false,
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    renderer = {
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " → ",
            show = {
                file = true,
                folder = true,
                folder_arrow = false,
                git = true,
            },
        },
    },
    filesystem_watchers = {
        enable = true,
    },
}


-- Spell check setup - default off, use :set spell to turn on
vim.opt.spell = false
vim.opt.spelllang = { 'en_us' }


-- Automatically close the tab/vim when nvim-tree is the last window in the tab
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('CloseNvimTreeWhenLast', {}),
    command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
    nested = true,
})
