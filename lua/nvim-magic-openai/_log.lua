local plenary_log = require('plenary.log')

local LOGLEVEL_ENVVAR = 'NVIM_MAGIC_LOGLEVEL'

local function get_loglevel()
	local level = vim.fn.getenv(LOGLEVEL_ENVVAR)
	if level == vim.NIL then
		return 'info'
	end
	return level
end

local log = plenary_log.new({
	plugin = 'nvim-magic-openai',
	level = get_loglevel(),
})
log.fmt_debug('Logger initialized level=%s', log.level)

return log
