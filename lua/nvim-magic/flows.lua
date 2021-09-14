-- helpful flows that can be mapped to key bindings
-- they can assume sensible defaults and/or interact with the user
local M = {}

local buffer = require('nvim-magic.buffer')
local keymaps = require('nvim-magic.keymaps')
local log = require('nvim-magic.log')
local templates = require('nvim-magic.templates')
local ui = require('nvim-magic.ui')

local function notify_prefix(filename)
	local prefix
	if 1 <= #filename then
		prefix = string.format('%s - ', filename)
	else
		prefix = '(buffer) -'
	end
	return prefix
end

function M.append_completion(backend, max_tokens, stops)
	assert(backend ~= nil, 'backend must be provided')
	if max_tokens ~= nil then
		assert(type(max_tokens) == 'number', 'max tokens must be a number')
		assert(1 <= max_tokens, 'max tokens must be at least 1')
	else
		max_tokens = 300
	end
	if stops ~= nil then
		assert(type(stops) == 'table', 'stop must be an array of strings')
		assert(type(stops[1]) == 'string', 'stop must be an array of strings')
	end

	local orig_bufnr, orig_winnr = buffer.get_handles()
	local filename = buffer.get_filename()
	local nprefix = notify_prefix(filename)

	local visual_lines, _, _, end_row, end_col = buffer.get_visual_lines()
	if not visual_lines then
		ui.notify(nprefix .. 'nothing selected')
		return
	end

	log.fmt_debug('Fetching completion max_tokens=%s stops=%s', max_tokens, vim.inspect(stops))
	ui.notify(nprefix .. 'fetching completion...')
	backend:complete(visual_lines, max_tokens, stops, function(completion)
		local compl_lines = vim.split(completion, '\n', true)

		buffer.append(orig_bufnr, end_row, end_col, compl_lines) -- TODO: use extmarks
		vim.api.nvim_set_current_win(orig_winnr)
		vim.api.nvim_set_current_buf(orig_bufnr)
		vim.api.nvim_win_set_cursor(0, { end_row, end_col }) -- TODO: use specific window

		ui.notify(nprefix .. 'fetched completion (' .. tostring(#completion) .. ' characters)', 'info')
	end, function(errmsg)
		ui.notify(nprefix .. errmsg)
	end)
end

function M.suggest_alteration(backend, language)
	assert(backend ~= nil, 'backend must be provided')
	if language == nil then
		language = buffer.get_filetype()
	else
		assert(type(language) == 'string', 'language must be a string')
	end

	local orig_bufnr, orig_winnr = buffer.get_handles()
	local filename = buffer.get_filename()
	local nprefix = notify_prefix(filename)

	local visual_lines, start_row, start_col, end_row, end_col = buffer.get_visual_lines()
	if not visual_lines then
		ui.notify(nprefix .. 'nothing selected')
		return
	end

	ui.prompt_input('This code should be altered to...', keymaps.get_quick_quit(), function(task)
		local visual = table.concat(visual_lines, '\n')
		local tmpl = templates.loaded.alter
		local prompt = tmpl:fill({
			language = language,
			task = task,
			snippet = visual,
		})
		local prompt_lines = vim.fn.split(prompt, '\n', false)
		-- we default max tokens to a "large" value in case the prompt is large, this isn't robust
		-- ideally we would estimate the number of tokens in the prompt and then set a max tokens
		-- value proportional to that (e.g. 2x) and taking into account the max token limit as well
		local max_tokens = 1000
		local stops = { tmpl.stop_code }

		log.fmt_debug('Fetching alteration max_tokens=%s stops=%s', max_tokens, vim.inspect(stops))
		ui.notify(nprefix .. string.format('fetching suggested alteration (task=%s)', task))
		backend:complete(prompt_lines, max_tokens, stops, function(completion)
			ui.notify(nprefix .. 'fetched suggested alteration (' .. tostring(#completion) .. ' characters)', 'info')
			local compl_lines = vim.split(completion, '\n', true)
			vim.api.nvim_set_current_win(orig_winnr)
			vim.api.nvim_set_current_buf(orig_bufnr)

			ui.pop_up(
				compl_lines,
				language,
				{
					top = 'Suggested alteration',
					top_align = 'center',
					bottom = '[a] - append | [p] paste over',
					bottom_align = 'left',
				},
				vim.list_extend(keymaps.get_quick_quit(), {
					{
						'n',
						'a', -- append to original buffer
						function(_)
							buffer.append(orig_bufnr, end_row, end_col, compl_lines)
							vim.api.nvim_win_close(0, true)
						end,
						{ noremap = true },
					},
					{
						'n',
						'p', -- replace in original buffer
						function(_)
							vim.api.nvim_buf_set_text(
								orig_bufnr,
								start_row - 1,
								start_col - 1,
								end_row - 1,
								end_col - 1,
								compl_lines
							)
							vim.api.nvim_win_close(0, true)
						end,
						{ noremap = true },
					},
				})
			)
		end, function(errmsg)
			ui.notify(nprefix .. errmsg)
		end)
	end)
end

function M.suggest_docstring(backend, language)
	assert(backend ~= nil, 'backend must be provided')
	if language == nil then
		language = buffer.get_filetype()
	else
		assert(type(language) == 'string', 'language must be a string')
	end

	local orig_bufnr, orig_winnr = buffer.get_handles()
	local filename = buffer.get_filename()
	local nprefix = notify_prefix(filename)

	local vis_lines, start_row, start_col, end_row, end_col = buffer.get_visual_lines()
	if not vis_lines then
		ui.notify(nprefix .. 'nothing selected')
		return
	end

	local visual = table.concat(vis_lines, '\n')
	local tmpl = templates.loaded.docstring
	local prompt = tmpl:fill({
		language = language,
		snippet = visual,
	})
	local prompt_lines = vim.fn.split(prompt, '\n', false)
	-- we default max tokens to a "large" value in case the prompt is large, this isn't robust
	-- ideally we would estimate the number of tokens in the prompt and then set a max tokens
	-- value proportional to that (e.g. 2x) and taking into account the max token limit as well
	local max_tokens = 1000
	local stops = { tmpl.stop_code }

	log.fmt_debug('Fetching docstring max_tokens=%s stops=%s', max_tokens, tostring(stops))
	ui.notify(nprefix .. 'fetching suggested docstring...')
	backend:complete(prompt_lines, max_tokens, stops, function(completion)
		ui.notify(nprefix .. 'fetched suggested docstring (' .. tostring(#completion) .. ' characters)', 'info')
		local compl_lines = vim.split(completion, '\n', true)
		vim.api.nvim_set_current_win(orig_winnr)
		vim.api.nvim_set_current_buf(orig_bufnr)

		ui.pop_up(
			compl_lines,
			language,
			{
				top = 'Suggested alteration',
				top_align = 'center',
				bottom = '[a] - append | [p] paste over',
				bottom_align = 'left',
			},
			vim.list_extend(keymaps.get_quick_quit(), {
				{
					'n',
					'a', -- append to original buffer
					function(_)
						buffer.append(orig_bufnr, end_row, end_col, compl_lines)
						vim.api.nvim_win_close(0, true)
					end,
					{ noremap = true },
				},
				{
					'n',
					'p', -- replace in original buffer
					function(_)
						vim.api.nvim_buf_set_text(
							orig_bufnr,
							start_row - 1,
							start_col - 1,
							end_row - 1,
							end_col - 1,
							compl_lines
						)
						vim.api.nvim_win_close(0, true)
					end,
					{ noremap = true },
				},
			})
		)
	end, function(errmsg)
		ui.notify(nprefix .. errmsg)
	end)
end

return M
