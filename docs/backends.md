# Backends

A backend is a Lua table which implements the following `complete` method:

```lua
function BackendImpl:complete(prompt_lines, max_tokens, stop, success, fail)
	-- 	[[
	-- 		@param prompt_lines[type=table] a list of (full and partial) lines of text making up the prompt
	-- 		@param max_tokens[type=number] positive integer indicating the maximum number of tokens that should be returned
	-- 		@param stops[type=table] list of strings that will be recognized as stop codes when generating a completion - may be an empty table
	-- 		@param success[type=function] callback that should be called with the resulting completion string e.g. success(completion_text)
	-- 		@param fail[type=function] callback that should be called in case of an error with an appropriate error message e.g. fail(errmsg)
	-- 	]]
end
```

The `complete` method must call exactly one of the passed `success` or `fail` callbacks.

A custom backend can be passed in the `backends` hashmap of a config passed to this plugin's `setup()` function e.g.

```lua
require('nvim-magic').setup({backends = { custom = require('some-custom-backend').new() }})
```

The custom backend can then be used with flows as normal, an example keymapping might look like

```lua
	vim.api.nvim_set_keymap(  -- uses backends.custom instead of backends.default
		'v',
		'<Leader>mccs',
		"<Cmd>lua require('nvim-magic.flows').append_completion(require('nvim-magic').backends.custom)<CR>",
		{}
	)
```
