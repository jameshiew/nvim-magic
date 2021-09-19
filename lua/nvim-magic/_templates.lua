local templates = {}

local fs = require('nvim-magic._fs')
local log = require('nvim-magic._log')

local lustache = require('nvim-magic.vendor.lustache.src.lustache')

local TemplateMethods = {}

function TemplateMethods:fill(values)
	return lustache:render(self.template, values)
end

local TemplateMt = { __index = TemplateMethods }

function templates.new(tmpl, stop_code)
	local template = {
		template = tmpl,
		-- TODO: parse tags as well
		stop_code = stop_code,
	}
	return setmetatable(template, TemplateMt)
end

local function load(name)
	local prompt_dir = 'prompts/' .. name

	local tmpl = fs.read(vim.api.nvim_get_runtime_file(prompt_dir .. '/template.mustache', false)[1])
	local meta_raw = fs.read(vim.api.nvim_get_runtime_file(prompt_dir .. '/meta.json', false)[1])
	local meta = vim.fn.json_decode(meta_raw)

	return templates.new(tmpl, meta.stop_code)
end

templates.loaded = {}
for _, name in pairs({ 'alter', 'docstring' }) do
	templates.loaded[name] = load(name)
	log.fmt_debug('Loaded template=%s', name)
end

return templates
