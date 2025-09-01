return {
	{
		"tpope/vim-fugitive",
		keys = {
			{
				"<leader>gs",
				vim.cmd.Git,
				desc = "Git Service"
			},
		},
		config = function()
			local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})

			local autocmd = vim.api.nvim_create_autocmd

			autocmd("BufWinEnter", {
				group = Fugitive,
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end

					local bufnr = vim.api.nvim_get_current_buf()
					vim.keymap.set("n", "<leader>p", function()
						vim.cmd.Git("push")
					end, {
						buffer = bufnr,
						remap = false,
						desc = "Git [p]ush",
					})
				end,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},
}
