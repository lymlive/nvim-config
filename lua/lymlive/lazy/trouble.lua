return {
    {
        "folke/trouble.nvim",
        config = function()
            local trbl = require("trouble")
            trbl.setup({
                icons = true,
            })

            vim.keymap.set("n", "<leader>xx", function()
                trbl.toggle()
            end, { desc = "Trouble Toggle" })
            vim.keymap.set("n", "<leader>xw", function()
                trbl.toggle("workspace_diagnostics")
            end, { desc = "Trouble Workspace Diagnostics" })
            vim.keymap.set("n", "<leader>xd", function()
                trbl.toggle("document_diagnostics")
            end, { desc = "Trouble Document Diagnostics" })
            vim.keymap.set("n", "<leader>xq", function()
                trbl.toggle("quickfix")
            end, { desc = "Trouble Quick Fix" })
            vim.keymap.set("n", "<leader>xl", function()
                trbl.toggle("loclist")
            end, { desc = "Trouble Loclist" })
            vim.keymap.set("n", "<leader>xr", function()
                trbl.toggle("lsp_references")
            end, { desc = "Trouble Toggle LSP" })
            vim.keymap.set("n", "<leader>xy", function()
                trbl.toggle("lsp_definitions")
            end, { desc = "Trouble Toggle LSP Deffinitions" })
            vim.keymap.set("n", "<leader>xt", function()
                trbl.toggle("lsp_type_definitions")
            end, { desc = "Trouble Toggle LSP Type Deffinitions" })
        end
    }
}
