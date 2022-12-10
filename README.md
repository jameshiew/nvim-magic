# nvim-magic

![ci](https://github.com/jameshiew/nvim-magic/actions/workflows/ci.yml/badge.svg)

A pluggable framework for integrating AI code assistance into Neovim. The goals are to make using AI code assistance unobtrusive, and to make it easy to create and share new flows that use AI code assistance. Go to [quickstart](#quickstart) for how to install. It currently works with [OpenAI Codex](https://openai.com/blog/openai-codex/).

## Features

### Completion (`<Leader>mcs`)

<img 
	alt='Example of Python script being generated from a docstring'
	src='docs/gifs/completion.gif'
	/>

### Generating a docstring (`<Leader>mds`)

<img 
	alt='Example of Python function having a docstring generated'
	src='docs/gifs/docstring.gif'
	/>

### Asking for an alteration (`<Leader>mas`)

<img 
	alt='Example of Python function being altered'
	src='docs/gifs/suggest.gif'
	/>

## Quickstart

### Prerequisites

- latest stable version of Neovim (nightly may work as well)
- `curl`
- OpenAI API key

### Installation

```lua
-- using packer.nvim
use({
	'jameshiew/nvim-magic',
	config = function()
		require('nvim-magic').setup()
	end,
	requires = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim'
	}
})
```

See [docs/config.md](docs/config.md) if you want to override the default configuration e.g. to turn off the default keymaps, or use a different OpenAI engine than the default one (`davinci-codex`). Your OpenAI account might not have access to `davinci-codex` if it is not in the OpenAI Codex private beta (as of 2022-02-02).

Your API key should be made available to your Neovim session in an environment variable `OPENAI_API_KEY`. See [docs/openai.md](docs/openai.md) for more details. Note that API calls may be charged for by OpenAI depending on the engine used.

```shell
 export OPENAI_API_KEY='your-api-key-here'
```

### Keymaps

These flows have keymaps set by default for visual mode selections (though you can disable this by passing `use_default_keymap = false` in the setup config).

You can map your own key sequences to the predefined `<Plug>`s if you don't want to use the default keymaps.

| `<Plug>`                              | default keymap | mode   | action                                     |
| ------------------------------------- | -------------- | ------ | ------------------------------------------ |
| `<Plug>nvim-magic-append-completion`  | `<Leader>mcs`  | visual | Fetch and append completion                |
| `<Plug>nvim-magic-suggest-alteration` | `<Leader>mss`  | visual | Ask for an alteration to the selected text |
| `<Plug>nvim-magic-suggest-docstring`  | `<Leader>mds`  | visual | Generate a docstring                       |

## Development

There is a [development container](https://containers.dev/) specified under the [`.devcontainer`](.devcontainer/) directory, that builds and installs the latest stable version of Neovim, and sets it up to use the local `nvim-magic` repo as a plugin.
