function ColorMyPencils(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
    --[[
    if TransBackground then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    else
        vim.cmd("set background=dark")
    end
    --]]
end

return {
    {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup({
                transparent = true
            })
            ColorMyPencils()
        end
    },
}
