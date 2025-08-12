return {
	-- Notifications
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},
	-- LuaLine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			opt = true,
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "filesize", "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	-- BufferLine
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- 	opts = {
	-- 		options = {
	-- 			diagnostics = "nvim_lsp",
	-- 			diagnostics_indicator = function(_, _, diagnostics_dict, _)
	-- 				local s = " "
	-- 				for e, n in pairs(diagnostics_dict) do
	-- 					local sym = e == "error" and " "
	-- 						or (e == "warning" and " ")
	-- 						or (e == "info" and " ")
	-- 						or (e == "hint" and " ")
	-- 					s = s .. n .. sym
	-- 				end
	-- 				return s
	-- 			end,
	-- 			mode = "tabs",
	-- 		},
	-- 	},
	-- },
	-- Spectre
	{
		"nvim-pack/nvim-spectre",
		lazy = true,
		keys = {
			{
				"<leader>S",
				"<cmd>lua require('spectre').toggle()<CR>",
				desc = "Toggle Spectre",
			},
			{
				"<leader>SW",
				"<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
				desc = "Search current word",
				mode = { "n", "v" },
			},
			{
				"<leader>SF",
				"<cmd>lua require('spectre').open_file_search({select_word=true})<CR>",
				desc = "Search on current file",
			},
		},
		config = function()
			require("spectre").setup()
		end,
	},
	-- Icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},
}
