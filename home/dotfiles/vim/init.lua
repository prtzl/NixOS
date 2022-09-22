require'impatient'

require'nvim-autopairs'.setup {}

require'fidget'.setup {}

require'gitsigns'.setup {}

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

cmp.setup({
	-- Enable LSP snippets
	snippet = {
		expand = function(args)
			require 'luasnip'.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		-- Add tab support
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		})
	},

	-- Installed sources
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'omni' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'buffer' },
		{ name = 'treesitter' },
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
