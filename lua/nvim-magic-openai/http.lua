local M = {}

local random = require('nvim-magic-openai.random')

local curl = require('plenary.curl')

local ClientMethods = {}

function ClientMethods:post(api_endpoint, json_body, api_key)
	assert(type(api_key) == 'string', 'API key must be a string')
	assert(api_key ~= nil and api_key ~= '', 'empty API key')

	local req = {
		accept = 'application/json',
		raw_body = json_body,
		headers = {
			content_type = 'application/json',
		},
		timeout = 30000, -- milliseconds TODO: currently requires a fork of plenary
	}
	assert(req.auth == nil, 'auth details should be added only after caching!')

	local id = random.generate_timestamped_string()

	local req_filename = id .. '-request.json'
	local req_json = vim.fn.json_encode(req)
	self.cache:save(req_filename, req_json)

	-- using basic auth instead of bearer auth because plenary.curl doesn't support bearer auth rn
	req.auth = ':' .. api_key

	local res = curl.post(api_endpoint, req)

	local res_filename = id .. '-response.json'
	local res_json = vim.fn.json_encode(res)
	self.cache:save(res_filename, res_json)

	assert(type(res.exit) == 'number')
	assert(res.exit == 0, 'curl call failed with exit code ' .. tostring(res.exit))

	assert(res.status == 200, 'non-200 HTTP status = see ' .. res_json .. ' for raw response')
	return res.body
end

local ClientMt = { __index = ClientMethods }

function M.new(cache)
	assert(type(cache) == 'table', 'cache must be a table with a method save(filename, contents)')
	return setmetatable({
		cache = cache,
	}, ClientMt)
end

return M
