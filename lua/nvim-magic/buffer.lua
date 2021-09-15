local M = {}

local log = require('nvim-magic.log')

local ESC_FEEDKEY = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

function M.get_handles()
	local winnr = vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	return bufnr, winnr
end

function M.get_filename()
	return vim.fn.expand('%:t')
end

function M.get_filetype(bufnr)
	if not bufnr then
		bufnr = 0
	end
	return vim.api.nvim_buf_get_option(bufnr, 'filetype')
end

function M.append(bufnr, row, col, lines)
	vim.api.nvim_buf_set_text(bufnr, row - 1, col - 1, row - 1, col - 1, lines)
	log.fmt_debug('Appended lines count=%s row=%s col=%s)', #lines, row, col)
end

function M.get_visual_lines(bufnr)
	if not bufnr then
		bufnr = 0
	end

	local start_row, start_col, end_row, end_col = M.get_visual_start_end()
	if start_row == end_row and start_col == end_col then
		return nil
	end
	log.fmt_debug(
		'Visual bounds start_row=%s start_col=%s end_row=%s end_col=%s',
		start_row,
		start_col,
		end_row,
		end_col
	)

	local visual_lines = M.get_lines(bufnr, start_row, start_col, end_row, end_col)

	return visual_lines, start_row, start_col, end_row, end_col
end

-- should be called while in visual mode only
function M.get_visual_start_end()
	-- NB: switches out of visual mode then back again to ensure marks are current
	vim.api.nvim_feedkeys(ESC_FEEDKEY, 'n', true)
	vim.api.nvim_feedkeys('gv', 'x', false)
	vim.api.nvim_feedkeys(ESC_FEEDKEY, 'n', true)

	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

	return start_row, start_col, end_row, end_col
end

-- gets full and partial lines between start and end
function M.get_lines(bufnr, start_row, start_col, end_row, end_col)
	if not bufnr then
		bufnr = 0
	end
	if start_row == end_row and start_col == end_col then
		return {}
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
	lines[1] = lines[1]:sub(start_col, -1)
	if #lines == 1 then -- visual selection all in the same line
		lines[1] = lines[1]:sub(1, end_col - start_col + 1)
	else
		lines[#lines] = lines[#lines]:sub(1, end_col)
	end
	return lines
end

return M
