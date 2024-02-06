return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- build = ":TSUpdate",
        config = function ()
            local install = require("nvim-treesitter.install")

            install.compilers = { "clang", "gcc" }

            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
}
