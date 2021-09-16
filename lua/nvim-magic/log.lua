local plenary_log = require('plenary.log')

local LOGLEVEL_ENVVAR = 'NVIM_MAGIC_LOGLEVEL'

local function get_loglevel()
	local level = vim.fn.getenv(LOGLEVEL_ENVVAR)
	if level == vim.NIL then
		return 'info'
	end
	return level
end

local logger = plenary_log.new({
	plugin = 'nvim-magic',
	level = get_loglevel(),
})
logger.fmt_debug('Logger initialized level=%s', logger.level)

return logger
