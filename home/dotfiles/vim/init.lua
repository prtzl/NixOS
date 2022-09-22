require'impatient'

require'nvim-autopairs'.setup {}

require'fidget'.setup {}

require'gitsigns'.setup {}

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
			require 'luasnip'.lsp_expand(args.body)
		end,
	},

	mapping = ({
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
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
        { name = 'nvim_lua' },
        { name = 'omni' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'treesitter' },
	},

    -- Display suggestion type on the left
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. strings[1] .. " "
        kind.menu = "    (" .. strings[2] .. ")"

        return kind
      end,
    },

    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
})

cmp.setup.cmdline(':', {
	sources = {
		{ name = 'cmdline' }
	}
})

cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

-- lsp signature
require "lsp_signature".setup({
    hint_enable = false;
    toggle_key = '<C-s>',
    select_signature_key = '<C-l>'
})

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

local signs = {
	{ name = 'DiagnosticSignError', text = '🔥' },
	{ name = 'DiagnosticSignWarn', text = '⚠️' },
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
