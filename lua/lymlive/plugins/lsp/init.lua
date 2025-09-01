return {
	{
		"rmagatti/goto-preview",
		lazy = false,
		keys = {
			{
				"<leader>pd",
				function()
					require("goto-preview").goto_preview_definition()
				end,
				{ desc = "Preview Definition", silent = true },
			},
			{
				"<leader>pt",
				function()
					require("goto-preview").goto_preview_type_definition()
				end,
				{ desc = "Preview Type Definition", silent = true },
			},
			{
				"<leader>pi",
				function()
					require("goto-preview").goto_preview_type_definition()
				end,
				{ desc = "Preview Implementation", silent = true },
			},
			{
				"<leader>pr",
				function()
					require("goto-preview").goto_preview_references()
				end,
				{ desc = "Preview References", silent = true },
			},
			{
				"<leader>pc",
				function()
					require("goto-preview").close_all_win()
				end,
				{ desc = "Close Previews", silent = true },
			},
		},
		config = function()
			require("goto-preview").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					cs = { "csharpier" },
				},
			})
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format()
				require("conform").format()
			end, { desc = "LSP to [f]ormat the buffer" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		lazy = false,
		keys = {
			{
				"<leader>lr",
				function()
					local linters = require("lint").get_running()
					if #linters == 0 then
						return "󰦕"
					end
					return "󱉶 " .. table.concat(linters, ", ")
				end,
				desc = "Display attached linters",
			},
		},
		opts = {
			event = {
				"BufReadPre",
				"BufNewFile",
				"InsertLeave",
			},
			linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte = { "eslint" },
				-- css = { "stylelint" },
				-- html = { "stylelint" },
				-- scss = { "stylelint" },
				-- sass = { "stylelint" },
				php = { "phpstan" },
				markdown = { "markdownlint" },
				md = { "markdownlint" },
			},
			linters = {},
		},
		config = function(_, opts)
			local lint = require("lint")
			local M = {}
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			function M.debounce(ms, fn)
				local timer = vim.loop.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			function M.lint()
				-- Use nvim-lint's logic first:
				-- * checks if linters exist for the full filetype first
				-- * otherwise will split filetype by "." and add all those linters
				-- * this differs from conform.nvim which only uses the first filetype that has a formatter
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.INFO, { title = "nvim-lint" })
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.event, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"simrat39/inlay-hints.nvim",
			"folke/neodev.nvim",
			"nvimtools/none-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		keys = {
			{ "gd", require("telescope.builtin").lsp_definitions, desc = "Goto Definition" },
			{ "gr", require("telescope.builtin").lsp_references, desc = "Goto References" },
			{ "gI", require("telescope.builtin").lsp_implementations, desc = "Goto Implementation" },
			{ "<leader>D", require("telescope.builtin").lsp_type_definitions, desc = "Type Definition" },
			{ "<leader>ds", require("telescope.builtin").lsp_document_symbols, desc = "Document Symbols" },
			{
				"<leader>ws",
				require("telescope.builtin").lsp_dynamic_workspace_symbols,
				desc = "Workspace Symbols",
			},
			{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
			{ "<leader>fd", vim.diagnostic.open_float, desc = "Float Diagnostic" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Go to prev issue" },
			{ "]d", vim.diagnostic.goto_next, desc = "Go to next issue" },
			{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
			{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
			{ "<c-h>", vim.lsp.buf.signature_help, desc = "Signature Help" },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--

				lua_ls = {
					-- cmd = {...},
					-- filetypes { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}
			local null_ls = require("null-ls")
			null_ls.setup()
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
			require("mason-null-ls").setup({
				ensure_installed = {},
				automatic_installation = true,
			})
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		lazy = false,
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = true,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"sar/cmp-lsp.nvim",
			"hrsh7th/cmp-nvim-lua",
			"onsails/lspkind-nvim",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "copilot" },
				}, {
					{ name = "path" },
					{ name = "buffer", keyword_length = 5 },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[buf]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[api]",
							path = "[path]",
							luasnip = "[snip]",
							gh_issues = "[issues]",
						},
					}),
				},
			})
		end,
	},
}
