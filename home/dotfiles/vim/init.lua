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

-- Helper function for Super tab complete
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local luasnip = require 'luasnip'

-- Info on where does LSP information come from for a given suggestion
local lspkind = require 'lspkind'
lspkind.init()

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
	},

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. strings[1] .. " "
        kind.menu = "[" .. strings[2] .. "]"
        return kind
      end,
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
-- C/C++ LSP
require'lspconfig'.clangd.setup{
	--on_attach = require'on-attach',
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
	--on_attach = require'on-attach',
}

require'lspconfig'.texlab.setup{}

-- lsp signature
require "lsp_signature".setup({
    hint_enable = false;
    toggle_key = '<C-s>',
    select_signature_key = '<C-l>'
})

-- Sidebar signs
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

-- TODO: try to configure ccls
--require'lspconfig'.ccls.setup{
--}

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

-- Automatically close the tab/vim when nvim-tree is the last window in the tab
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('CloseNvimTreeWhenLast', {}),
	command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
	nested = true,
})
