return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				colorscheme = "mocha",
				-- transparent_background = true,
				dim_inactive = {
					enabled = false,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
}
