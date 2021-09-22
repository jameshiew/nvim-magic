local http = {}

local curl = require('nvim-magic-openai._curl')
local random = require('nvim-magic-openai._random')

local DEFAULT_TIMEOUT_MILLI = 30000

local ClientMethods = {}

function ClientMethods:post(api_endpoint, json_body, api_key, success, fail)
	assert(type(api_key) == 'string', 'API key must be a string')
	assert(api_key ~= nil and api_key ~= '', 'empty API key')

	local req = {
		accept = 'application/json',
		raw_body = json_body,
		headers = {
			content_type = 'application/json',
		},
		return_job = true,
	}

	local id = random.generate_timestamped_string()

	local req_filename = id .. '-request.json'
	local req_json = vim.fn.json_encode(req)
	assert(req.auth == nil, 'auth details should be added only after caching!')
	self.cache:save(req_filename, req_json)

	-- using basic auth instead of bearer auth because plenary.curl doesn't support bearer auth rn
	req.auth = ':' .. api_key

	local job, res_fn = curl.post(api_endpoint, req)
	job:start()

	local timer = vim.loop.new_timer()
	local interval_ms = 100
	local elapsed_ms = 0
	timer:start(
		0,
		interval_ms,
		vim.schedule_wrap(function()
			local res, errmsg = res_fn()
			if errmsg then
				timer:close()
				fail('error: ' .. errmsg)
				return
			end
			if res then
				local res_filename = id .. '-response.json'
				local res_json = vim.fn.json_encode(res)
				self.cache:save(res_filename, res_json)

				assert(type(res.exit) == 'number')
				if res.exit ~= 0 then
					timer:close()
					fail('curl call failed exit_code=' .. tostring(res.exit))
					return
				end

				if res.status ~= 200 then
					timer:close()
					fail('non-200 HTTP status response=' .. res_json)
					return
				end

				timer:close()
				success(res.body)
				return
			end

			elapsed_ms = elapsed_ms + interval_ms
			if elapsed_ms > DEFAULT_TIMEOUT_MILLI then
				timer:close()
				fail('timed out after milliseconds=' .. tostring(DEFAULT_TIMEOUT_MILLI))
				return
			end
		end)
	)
end

local ClientMt = { __index = ClientMethods }

function http.new(cache)
	assert(type(cache) == 'table', 'cache must be a table with a method save(filename, contents)')
	return setmetatable({
		cache = cache,
	}, ClientMt)
end

return http
