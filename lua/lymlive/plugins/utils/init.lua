return {
	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		}
	},
	{
		"laytan/cloak.nvim",
		lazy = false,
		config = function()
			local cloak = require("cloak")
			cloak.setup({
				enabled = true,
				cloak_character = "*",
				highlight_group = "Comment",
				patterns = {
					{
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						cloak_pattern = "=.+",
					},
				},
			})
		end,
		keys = {
			{ "<leader>ct", "<cmd>CloakToggle<cr>", desc = "Toggle Cloak" },
		},
	},
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		priority = 100,
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find Files" },
			{ "<leader>lg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live Grep" },
			{ "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Git Files" },
			{
				"<leader>of",
				"<cmd>lua require('telescope.builtin').oldfiles()<cr>",
				desc = "Find Recently Opened Files",
			},
			{
				"<leader>gd",
				"<cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
				desc = "LSP Definitions",
			},
			{
				"<leader>tk",
				"<cmd>lua require('telescope.builtin').keymaps()<cr>",
				desc = "Telescope Keymaps",
			},
			{
				"<leader>ds",
				"<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
				desc = "Document Symbols",
			},
			{
				"<leader>ws",
				"<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>",
				desc = "Workspace Symbols",
			},
			{ "<leader>gr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", desc = "References" },
			{
				"<leader>gD",
				"<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>",
				desc = "Type Definitions",
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = {
						"smart",
					},
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			lazy = true,
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("todo-comments").setup({
				signs = true, -- show icons in the signs column
				sign_priority = 8, -- sign priority
				-- keywords recognized as todo comments
				keywords = {
					FIX = {
						icon = " ", -- icon used for the sign, and in search results
						color = "error", -- can be a hex color, or a named color (see below)
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR", "DEBUG" }, -- a set of other keywords that all map to this FIX keywords
						-- signs = false, -- configure signs for some keywords individually
					},
					TODO = { icon = " ", color = "info" },
					HACK = { icon = " ", color = "hack", alt = { "DEV" } },
					WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = "󰊚 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
					TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				},
				gui_style = {
					fg = "NONE", -- The gui style to use for the fg highlight group.
					bg = "BOLD", -- The gui style to use for the bg highlight group.
				},
				merge_keywords = true, -- when true, custom keywords will be merged with the defaults
				-- highlighting of the line containing the todo comment
				-- * before: highlights before the keyword (typically comment characters)
				-- * keyword: highlights of the keyword
				-- * after: highlights after the keyword (todo text)
				highlight = {
					multiline = true, -- enable multiline todo comments
					multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
					multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
					before = "", -- "fg" or "bg" or empty
					keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
					after = "fg", -- "fg" or "bg" or empty
					pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
					comments_only = true, -- uses treesitter to match keywords in comments only
					max_line_len = 400, -- ignore lines longer than this
					exclude = {}, -- list of file types to exclude highlighting
				},
				-- list of named colors where we try to extract the guifg from the
				-- list of highlight groups or use the hex color if hl not found as a fallback
				colors = {
					error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
					warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
					info = { "DiagnosticInfo", "#6C25BE" },
					hint = { "DiagnosticHint", "#10B981" },
					default = { "Identifier", "#7C3AED" },
					test = { "Identifier", "#FF00FF" },
					hack = { "Identifier", "#FF8F00" },
				},
				search = {
					command = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
					},
					-- regex that will be used to match keywords.
					-- don't replace the (KEYWORDS) placeholder
					pattern = [[\b(KEYWORDS):]], -- ripgrep regex
					-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local install = require("nvim-treesitter.install")

			install.compilers = { "gcc", "cc" }

			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				sync_install = true,
				modules = {},
				ignore_install = {},
			})
		end,
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quick Fix" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Loclist" },
			{ "<leader>xr", "<cmd>Trouble lsp_references<cr>", desc = "Trouble Toggle LSP" },
			{ "<leader>xy", "<cmd>Trouble lsp_definitions<cr>", desc = "Trouble Toggle LSP Deffinitions" },
			{ "<leader>xt", "<cmd>Trouble lsp_type_definitions<cr>", desc = "Trouble Toggle LSP Type Deffinitions" },
		},
		config = function()
			local trbl = require("trouble")
			trbl.setup()
		end,
	},
	{
		"mbbill/undotree",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [u]ndotree" })
		end,
	},
}
