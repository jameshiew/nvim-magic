local magic = {}

local log = require('nvim-magic._log')

magic.backends = {} -- should be set during setup()

function magic.default_cfg()
	return {
		backends = {
			default = require('nvim-magic-openai').new(),
		},
		use_default_keymap = true,
	}
end

function magic.version()
	return '0.3.0-dev'
end

function magic.setup(override)
	local config = magic.default_cfg()

	if override then
		if override.backends then
			assert(type(override.backends) == 'table', 'backends must be an array of backends')
			assert(type(override.backends.default) == 'table', 'backends must be an array of backends')
			for name, backend in pairs(override.backends) do
				assert(type(backend.complete) == 'function', 'backend ' .. name .. ' needs a complete function')
			end
			config.backends = override.backends
		end
		if override.use_default_keymap then
			assert(type(override.use_default_keymap == 'boolean'), 'use_default_keymap must be a boolean')
			config.use_default_keymap = override.use_default_keymap
		end
	end

	log.fmt_debug('Got config=%s ', config)

	magic.backends = config.backends

	if config.use_default_keymap then
		require('nvim-magic._keymaps').set_default()

		log.debug('Set default keymaps')
	end
end

return magic
