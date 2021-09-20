local fs = {}

local pathlib = require('plenary.path')

function fs.read(path)
	-- @returns [string]
	assert(path ~= nil, 'path cannot be nil')
	assert(type(path) == 'string', 'path must be a string')
	local fh, errmsg = io.open(path, 'r')
	assert(errmsg == nil, errmsg)
	local contents = fh:read('*all')
	fh:close()
	return contents
end

function fs.chomp_path_separator(s)
	if s:sub(-1) ~= pathlib.path.sep then
		error('string does not end with trailing path separator')
	end
	return s:sub(1, -2)
end

function fs.get_dir_name(path)
	return vim.fn.fnamemodify(fs.chomp_path_separator(path), ':t')
end

return fs
