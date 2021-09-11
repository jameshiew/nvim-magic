local M = {}

local log = require('nvim-magic.log')

M.backends = {} -- should be set during setup()

function M.default_cfg()
	return {
		backends = {
			default = require('nvim-magic-openai').new(),
		},
		use_default_keymap = true,
	}
end

function M.setup(override)
	local config = M.default_cfg()

	if override ~= nil then
		if override.backends ~= nil then
			assert(type(override.backends) == 'table', 'backends must be an array of backends')
			assert(type(override.backends.default) == 'table', 'backends must be an array of backends')
			for name, backend in pairs(override.backends) do
				assert(
					type(backend.complete_sync) == 'function',
					'backend ' .. name .. ' needs a complete_sync function'
				)
			end
			config.backends = override.backends
		end
		if override.use_default_keymap ~= nil then
			assert(type(override.use_default_keymap == 'boolean'), 'use_default_keymap must be a boolean')
			config.use_default_keymap = override.use_default_keymap
		end
	end

	log.fmt_debug('Got config=%s ', config)

	M.backends = config.backends

	if config.use_default_keymap then
		require('nvim-magic.keymaps').set_default()

		log.debug('Set default keymaps')
	end
end

return M
