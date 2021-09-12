# nvim-magic

A pluggable framework for integrating AI code assistance into Neovim. The goals are to make using AI code assistance unobtrusive, and to make it easy to create and share new flows that use AI code assistance.

## Features

* Completion
* Asking for an alteration
* Generating a docstring

## Quickstart

At the moment, only a backend for [OpenAI](https://beta.openai.com/) is implemented, which is bundled in this repo and used by default. Your API key should be made available to your Neovim session in an environment variable `OPENAI_API_KEY`. See [docs/openai.md](docs/openai.md) for more details.

```shell
export OPENAI_API_KEY='your-api-key-here'
```

Install like any other plugin. It is necessary to call `setup()` once see [docs/config.md](docs/config.md) if you want to override the default configuration e.g. to turn off the default keymaps.

```lua
-- using packer.nvim
use({
	'jameshiew/nvim-magic',
	config = function()
		require('nvim-magic').setup()
	end,
	requires = {
		'jameshiew/plenary.nvim',  -- fork of nvim-lua/plenary.nvim which allows a longer request timeout, the original can be used if wanted
		'MunifTanjim/nui.nvim'
	}
})
```

### Default Keymaps

These keys are mapped for visual mode selections by default (though you can disable this by passing `use_default_keymap = false` in the setup config).

| keys | mode | action|
|--|--|--|
|`<Leader>mcs`| visual | Fetch and append completion|
|`<Leader>mss`| visual | Ask for an alteration to the selected text|
|`<Leader>mds`| visual | Generate a docstring|

