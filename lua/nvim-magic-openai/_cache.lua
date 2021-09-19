local cache = {}

local log = require('nvim-magic-openai._log')
local pathlib = require('plenary.path')

local DIR = pathlib.new(vim.fn.stdpath('cache')):joinpath('nvim-magic-openai')
DIR:mkdir({ parents = true, exist_ok = true })

local CacheMethods = {}

function CacheMethods:save(filename, contents)
	local path = tostring(self.directory:joinpath(filename))
	local fh, errmsg = io.open(path, 'w')
	assert(errmsg == nil, errmsg)
	fh:write(contents)
	fh:close()
	log.fmt_debug('Saved to cache path=%s', path)
end

local CacheMt = { __index = CacheMethods }

function cache.new(directory)
	assert(type(directory) == 'string' and directory ~= '')
	local directory_path = DIR:joinpath(directory)
	directory_path:mkdir({ parents = true, exist_ok = true })

	return setmetatable({
		directory = directory_path,
	}, CacheMt)
end

-- for use when caching isn't wanted
local DummyCacheMethods = {}

function DummyCacheMethods:save(filename, _) -- luacheck: ignore
	log.fmt_debug('Dummy cache received request to save filename=%s', filename)
end

local DummyCacheMt = { __index = DummyCacheMethods }

function cache.new_dummy()
	return setmetatable({}, DummyCacheMt)
end

return cache
