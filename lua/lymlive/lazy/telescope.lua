return {
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = {
                        "smart"
                    },
                },
                extensions = {
                    project = {
                        base_dirs = {
                        }
                    }
                }
            })

            require('telescope').load_extension('project')

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "[f]ind [f]iles search" })
            vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "[l]ive [g]rep" })
            vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Serch the files in the git project" })
            vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = 'Find recently [o]pened [f]iles' })
            vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = "[l]sp [d]effinitions" })
            vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = "[t]elescope [k]eymaps" })

            vim.keymap.set('n', '<leader>tp', function()
                vim.cmd("Telescope project")
            end, { desc = "[t]elescope [p]rojects" })
        end
    },
}
