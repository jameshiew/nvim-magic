# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [0.2.0] - 2021-09-14

### Changed
* Use Vim notifications for info messages instead of echoing them
* Vendor forked curl code from [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) so that upstream plenary.nvim can be required as a dependency without issue
* No longer freeze up Neovim while completions are being fetched ([#1](https://github.com/jameshiew/nvim-magic/issues/1))

### Fixed
* Using a default keymap in a buffer should work first time rather than just deselecting the current visual selection ([#2](https://github.com/jameshiew/nvim-magic/issues/2))

## [0.1.0] - 2021-09-13

[0.2.0]: https://github.com/jameshiew/nvim-magic/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/jameshiew/nvim-magic/releases/tag/v0.1.0