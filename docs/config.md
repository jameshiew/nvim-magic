# Config

## Options
| key                | default value | description                                              |
| ------------------ | ------------- | -------------------------------------------------------- |
| use_default_keymap | true          | enables the default keybind for injecting generated code |
| backends            | { default = require('nvim-magic-openai').new() } | used in code assistance flows, at least a `default` backend should be specified                                    |

For enabling logging, there is also the `NVIM_MAGIC_LOGLEVEL` environment variable which can be set to a loglevel.

```shell
export NVIM_MAGIC_LOGLEVEL='debug'
```

## Default
The default config is as follows:

```lua
{
	backends = {
		default = require('nvim-magic-openai').new(),
	},
	use_default_keymap = true,
}
```

## Passing extra configuration
Extra config should be passed as a hashtable to the initial `require('nvim-magic').setup()` call. It will be merged with the default config and override any default values.

e.g. to override the default backend to use the OpenAI `cushman-codex` engine, and not set the default keymaps.

```lua
require('nvim-magic').setup({
	backends = {
		default = require('nvim-magic-openai').new({
			api_endpoint = 'https://api.openai.com/v1/engines/cushman-codex/completions',
		}),
	},
	use_default_keymap = false
})
```
