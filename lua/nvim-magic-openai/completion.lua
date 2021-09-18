local completion = {}

function completion.new_request(prompt, max_tokens, stops)
	assert(type(prompt) == 'string', 'prompt must be a string')
	assert(type(max_tokens) == 'number', 'max tokens must be a number')
	if stops then
		assert(type(stops) == 'table', 'stops must be an array of strings')
	end

	return {
		prompt = prompt,
		temperature = 0,
		max_tokens = max_tokens,
		n = 1,
		top_p = 1,
		stop = stops,
		frequency_penalty = 0,
		presence_penalty = 0,
	}
end

function completion.extract_from(res_body)
	local decoded = vim.fn.json_decode(res_body)
	assert(decoded ~= nil, "couldn't decode body")
	assert(decoded.choices ~= nil, 'no choices returned')
	return decoded.choices[1].text
end

return completion
