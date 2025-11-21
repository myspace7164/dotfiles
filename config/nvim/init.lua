vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2
vim.opt.winborder = "rounded"

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.config('nixd', {
	formatting = {
		command = { "nixfmt" },
	}
}
)

vim.lsp.enable({
	'lua_ls',
	'nixd',
	'texlab',
	'tinymist',
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.cmd([[colorscheme modus]])

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>lf', function()
	vim.lsp.buf.format({ async = true })
end, { desc = 'LSP Format buffer' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Telescope help tags' })
