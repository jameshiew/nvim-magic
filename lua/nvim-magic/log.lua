local log = nil

local level = vim.fn.getenv('NVIM_MAGIC_LOGLEVEL')
if level == vim.NIL then
	level = 'info'
end

return (function()
	if log == nil then
		log = require('plenary.log').new({
			plugin = 'nvim-magic',
			level = level,
		})
	end
	return log
end)()
