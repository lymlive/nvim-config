return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "simrat39/rust-tools.nvim",
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lua',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets'
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.preset("recommended")
            lsp_zero.extend_lspconfig()


            local on_windows = vim.loop.os_uname().version:match 'Windows'
            local lspconfig = require('lspconfig')
            local configs = require('lspconfig.configs')

            local on_attach = function(_, bufnr)
                local buf_set_option = function(...)
                    vim.api.nvim_buf_set_option(bufnr, ...)
                end
                buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
            end

            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                opts.desc = "[g]o to [d]effinition"
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                opts.desc = "Hover deffinition"
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                opts.desc = "open workspace symbols"
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                opts.desc = "open float diagnostic"
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                opts.desc = "go to next issue"
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                opts.desc = "go to prev issue"
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
                opts.desc = "visual code action"
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                opts.desc = "Visual References"
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                opts.desc = "[v]isual [r]e[n]ame"
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                opts.desc = "signature help"
                vim.keymap.set("i", "<c-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'tsserver', 'rust_analyzer' },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                }
            })

            vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references,
                { desc = '[g]oto [r]eferences' })
            vim.keymap.set('n', '<leader>gt', require('telescope.builtin').lsp_implementations,
                { desc = '[g]o[t]o Implementation' })
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type [D]efinition' })
            vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
                { desc = '[d]ocument [s]ymbols' })
            vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                { desc = '[w]orkspace [s]ymbols' })

            local cmp = require('cmp')
            --local cmp_select = { behaviour = cmp.SelectBehaviour.Select }

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    --['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    --['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                }),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'luasnip', keyword_length = 2 },
                    { name = 'buffer',  keyword_length = 3 },
                })
            })

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
