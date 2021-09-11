local M = {}

function M.get_quick_quit()
	return {
		{
			'n',
			'q',
			function(_)
				vim.api.nvim_win_close(0, true)
			end,
			{ noremap = true },
		},
		{
			'n',
			'<ESC>',
			function(_)
				vim.api.nvim_win_close(0, true)
			end,
			{ noremap = true },
		},
	}
end

function M.set_default()
	vim.api.nvim_set_keymap(
		'v',
		'<Leader>mcs',
		"<Cmd>lua require('nvim-magic.flows').append_completion(require('nvim-magic').backends.default)<CR>",
		{}
	)
	vim.api.nvim_set_keymap(
		'v',
		'<Leader>mss',
		"<Cmd>lua require('nvim-magic.flows').suggest_alteration(require('nvim-magic').backends.default)<CR>",
		{}
	)
	vim.api.nvim_set_keymap(
		'v',
		'<Leader>mds',
		"<Cmd>lua require('nvim-magic.flows').suggest_docstring(require('nvim-magic').backends.default)<CR>",
		{}
	)
end

return M
