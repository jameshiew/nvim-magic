-- packer bootstrapping code from
-- <https://github.com/wbthomason/packer.nvim/tree/64ae65fea395d8dc461e3884688f340dd43950ba#bootstrapping>
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use({
        '/workspaces/nvim-magic',
        config = function()
            require('nvim-magic').setup()
        end,
        requires = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim'
        }
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
