# OpenAI

The OpenAI backend is provided and uses the [`davinci-codex`](https://beta.openai.com/docs/engines/codex-series-private-beta) engine by default as that is the most useful for code.

## Configuration

### Options

| key          | default value                                               | description                                                                                                                          |
| ------------ | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| api_endpoint | https://api.openai.com/v1/engines/davinci-codex/completions | v1 create completion HTTP POST endpoint, replace `davinci-codex` with another engine name to use a different engine                                                                                              |
| cache        | `{ dir_name = 'http' }`                                     | requests/responses will be saved under to `stdpath('cache') .. '/nvim-magic-openai/' .. cache.dir_name`, set to `nil` to disable this functionality |

### API Key

The API key must be provided via an `OPENAI_API_KEY` environment variable.

## Security

Be aware of the following:

Since the API key is passed as an environment variable to Neovim, it could be exposed to other processes. It will be visible if the environment of the Neovim process is inspected using something like `htop`, for example.

