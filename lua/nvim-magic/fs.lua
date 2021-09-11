local M = {}

function M.read(path)
	-- @returns [string]
	assert(path ~= nil, 'path cannot be nil')
	assert(type(path) == 'string', 'path must be a string')
	local fh, errmsg = io.open(path, 'r')
	assert(errmsg == nil, errmsg)
	local contents = fh:read('*all')
	fh:close()
	return contents
end

return M
