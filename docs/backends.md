# Backends

A backend is a Lua table which implements the following method:

```lua
function BackendImpl:complete_sync(prompt_lines, max_tokens, stop)
	-- 	[[
	-- 		@param prompt_lines[type=table] a list of (full and partial) lines of text making up the prompt
	-- 		@param max_tokens[type=number] positive integer indicating the maximum number of tokens that should be returned
	-- 		@param stops[type=table|nil] (optional) list of string that will be recognized as stop codes when generating a completion
	-- 		@returns [string] the completion for the provided prompt lines
	-- 	]]
end
```

It can be passed in the `backends` hashmap of a config passed to this plugin's `setup()` function e.g.

```lua
require('nvim-magic').setup({backends = { custom = require('some-custom-backend').new() }})
```

The backend can then be used with flows as normal, an example keymapping might look like

```lua
	vim.api.nvim_set_keymap(  -- uses backends.custom instead of backends.default
		'v',
		'<Leader>mccs',
		"<Cmd>lua require('nvim-magic.flows').append_completion(require('nvim-magic').backends.custom)<CR>",
		{}
	)
```
