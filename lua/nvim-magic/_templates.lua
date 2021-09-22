local templates = {}

local fs = require('nvim-magic._fs')
local log = require('nvim-magic._log')

local lustache = require('nvim-magic.vendor.lustache.src.lustache')

-- prompts live in directories that are two levels under a PROMPTS_RUNTIME_DIRNAME directory on the runtime path
-- e.g. prompts/nvim-magic/alter/ contains a prompt
local PROMPTS_RUNTIME_DIRNAME = 'prompts/'

local TemplateMethods = {}

function TemplateMethods:fill(values)
	return lustache:render(self.template, values)
end

local TemplateMt = { __index = TemplateMethods }

function templates.new(tmpl, stop_code)
	assert(tmpl)
	assert(stop_code)
	local template = {
		template = tmpl,
		-- TODO: parse tags as well
		stop_code = stop_code,
	}
	return setmetatable(template, TemplateMt)
end

function templates.load(prompt_dir)
	local tmpl = fs.read(vim.api.nvim_get_runtime_file(prompt_dir .. '/template.mustache', false)[1])
	local meta_raw = fs.read(vim.api.nvim_get_runtime_file(prompt_dir .. '/meta.json', false)[1])
	local meta = vim.fn.json_decode(meta_raw)

	return templates.new(tmpl, meta.stop_code)
end

local function dedupe(list)
	local deduped = {}
	for _, elem in pairs(list) do
		if not vim.tbl_contains(deduped, elem) then
			table.insert(deduped, elem)
		end
	end
	return deduped
end

local function prompts_dirs()
	local dirs = vim.api.nvim_get_runtime_file(PROMPTS_RUNTIME_DIRNAME .. '*/', true)
	return dedupe(dirs)
end

return (function()
	templates.loaded = {}
	for _, dir_path in pairs(prompts_dirs()) do
		-- TODO: handle conflicting directory names
		local dir_name = fs.get_dir_name(dir_path)
		assert(not templates.loaded[dir_name])
		templates.loaded[dir_name] = {}

		local subdirs = dedupe(vim.api.nvim_get_runtime_file(PROMPTS_RUNTIME_DIRNAME .. dir_name .. '/*/', true))
		for _, subdir in pairs(subdirs) do
			local subdir_name = fs.get_dir_name(subdir)
			assert(not templates.loaded[dir_name][subdir_name])
			templates.loaded[dir_name][subdir_name] = templates.load(PROMPTS_RUNTIME_DIRNAME .. dir_name .. '/' .. subdir_name)
			log.fmt_debug('Loaded package=%s template=%s', dir_name, subdir_name)
		end
	end

	return templates
end)()
