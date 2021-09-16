local fs = {}

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

function fs.chomp_slash(s)
	if s:sub(-1) ~= '/' then
		error('string does not end with trailing slash')
	end
	return s:sub(1, -2)
end

function M.get_dir_name(path)
	return vim.fn.fnamemodify(M.chomp_slash(path), ':t')
end

return fs
