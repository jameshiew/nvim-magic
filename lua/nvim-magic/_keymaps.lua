local keymaps = {}

local function luacmd(lua)
	return '<Cmd>lua ' .. lua .. '<CR>'
end

keymaps.plugs = {
	['<Plug>nvim-magic-append-completion'] = {
		default_keymap = '<Leader>mcs',
		lua = "require('nvim-magic.flows').append_completion(require('nvim-magic').backends.default)",
	},
	['<Plug>nvim-magic-suggest-alteration'] = {
		default_keymap = '<Leader>mss',
		lua = "require('nvim-magic.flows').suggest_alteration(require('nvim-magic').backends.default)",
	},
	['<Plug>nvim-magic-suggest-docstring'] = {
		default_keymap = '<Leader>mds',
		lua = "require('nvim-magic.flows').suggest_docstring(require('nvim-magic').backends.default)",
	},
}

for plug, v in pairs(keymaps.plugs) do
	vim.api.nvim_set_keymap('v', plug, luacmd(v.lua), {})
end

function keymaps.set_default()
	for plug, v in pairs(keymaps.plugs) do
		vim.api.nvim_set_keymap('v', v.default_keymap, plug, {})
	end
end

function keymaps.get_quick_quit()
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

return keymaps
