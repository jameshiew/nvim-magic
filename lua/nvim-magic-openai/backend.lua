local M = {}

local completion = require('nvim-magic-openai.completion')

local log = require('nvim-magic.log')

local BackendMethods = {}

function BackendMethods:complete_sync(lines, max_tokens, stops)
	local prompt = table.concat(lines, '\n')
	log.fmt_debug('Fetching completion prompt_length=%s max_tokens=%s stops=%s', #prompt, max_tokens, tostring(stops))

	local req_body = completion.new_request(prompt, max_tokens, stops)
	local req_body_json = vim.fn.json_encode(req_body)

	local res_body = self.http:post(self.api_endpoint, req_body_json, self.get_api_key())

	return completion.extract_from(res_body)
end

local BackendMt = { __index = BackendMethods }

function M.new(api_endpoint, http, api_key_fn)
	return setmetatable({
		api_endpoint = api_endpoint,
		get_api_key = api_key_fn,
		http = http,
	}, BackendMt)
end

return M
