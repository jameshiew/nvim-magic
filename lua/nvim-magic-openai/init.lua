local openai = {}

local cache = require('nvim-magic-openai.cache')
local backend = require('nvim-magic-openai.backend')
local http = require('nvim-magic-openai.http')

local log = require('nvim-magic.log')

local DEFAULT_API_ENDPOINT = 'https://api.openai.com/v1/engines/davinci-codex/completions'
local API_KEY_ENVVAR = 'OPENAI_API_KEY'

local function env_get_api_key()
        local api_key = ''
        if vim.g[API_KEY_ENVVAR] then
            api_key = vim.g[API_KEY_ENVVAR]
        elseif vim.env[API_KEY_ENVVAR] then
            api_key = vim.env[API_KEY_ENVVAR]
        end

        assert(api_key ~= nil or api_key ~= '', string.format(
                'Any of let g:%s or $%s must be set in your vim or environment config respectively',
                API_KEY_ENVVAR,
                API_KEY_ENVVAR))

        return api_key
end

function openai.default_cfg()
	return {
		api_endpoint = DEFAULT_API_ENDPOINT,
		cache = {
			dir_name = 'http',
		},
	}
end

function openai.new(override)
	local config = openai.default_cfg()

	if override then
		assert(type(override) == 'table', 'config must be a table')

		if override.api_endpoint then
			assert(
				type(override.api_endpoint) == 'string' and 1 <= #override.api_endpoint,
				'api_endpoint must be a non-empty string'
			)
			config.api_endpoint = override.api_endpoint
		end

		if not override.cache then
			config.cache = nil
		else
			assert(type(override.cache) == 'table', 'cache must be a table or nil')
			assert(
				type(override.cache.dir_name) == 'string' and 1 <= #override.cache.dir_name,
				'cache.dir_name must be a non-empty string'
			)
			config.cache = override.cache
		end
	end

	log.fmt_debug('nvim-magic-openai config=%s', config)

	local http_cache
	if config.cache then
		http_cache = cache.new(config.cache.dir_name)
	else
		log.fmt_debug('Using dummy cache')
		http_cache = cache.new_dummy()
	end

	return backend.new(config.api_endpoint, http.new(http_cache), env_get_api_key)
end

return openai
