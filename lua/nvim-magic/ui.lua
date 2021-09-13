-- interacting with the user
local M = {}

local Input = require('nui.input')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

function M.notify(msg, log_level, opts)
	vim.notify('nvim-magic: ' .. msg)
end

function M.pop_up(lines, filetype, border_text, keymaps)
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = 'rounded',
			highlight = 'Bold',
			text = border_text,
		},
		position = '50%',
		size = {
			width = '80%',
			height = '60%',
		},
		buf_options = {
			modifiable = true,
			readonly = false,
			filetype = filetype,
			buftype = 'nofile',
		},
	})
	popup:mount()
	vim.cmd([[set number]]) -- for some reason, using number=true in buf_options doesn't work so we do this instead
	popup:on(event.BufLeave, function()
		popup:unmount()
	end)

	for _, v in ipairs(keymaps) do
		popup:map(unpack(v))
	end

	vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
end

function M.prompt_input(title, keymaps, on_submit)
	local input = Input({
		position = '20%',
		size = {
			width = '60%',
			height = '20%',
		},
		relative = 'editor',
		border = {
			highlight = 'MyHighlightGroup',
			style = 'single',
			text = {
				top = title,
				top_align = 'center',
			},
		},
		win_options = {
			winblend = 10,
			winhighlight = 'Normal:Normal',
		},
	}, {
		prompt = '> ',
		default_value = '',
		on_close = function() end,
		on_submit = on_submit,
	})
	input:mount()
	input:on(event.BufLeave, function()
		input:unmount()
	end)

	for _, v in ipairs(keymaps) do
		input:map(unpack(v))
	end
end

return M
