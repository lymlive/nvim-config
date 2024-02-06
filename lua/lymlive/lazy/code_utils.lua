return {
    {
        "echasnovski/mini.pairs",
        opts = {},
        keys = {
            {
                "<leader>up",
                function()
                    vim.g.minipairs_disable = not vim.g.minipairs_disable
                    if vim.g.minipairs_disable then
                        vim.notify("Disabled auto pairs", vim.log.levels.WARN, { title = "Option" })
                    else
                        vim.notify("Enabled auto pairs", vim.log.levels.INFO, { title = "Option" })
                    end
                end,
                desc = "Toggle auto pairs",
            },
        },
    },
}
