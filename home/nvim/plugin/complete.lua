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

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        --['<S-Tab>'] = cmp.mapping.select_prev_item(),
        --['<Tab>'] = cmp.mapping.select_next_item(),
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
        -- Language servers and snippets
        { name = 'nvim_lsp' },
        { name = 'luasnip' },

        -- Other sources
        { name = 'buffer' },
        { name = 'treesitter' },
        { name = 'omni' },
        { name = 'path' },
        { name = 'spell', option = { keep_all_entries = false }, },
        { name = 'nvim_lua' },
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
        '--clang-tidy',
        '--compile-commands-dir=build',
        '--header-insertion=never',
        '--function-arg-placeholders',
        '--header-insertion-decorators',
    },
    filetypes = { "c", "cpp", "h", "hpp" },
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

