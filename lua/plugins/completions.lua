return {
    {
        "hrsh7th/cmp-omni",
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            local ap = require("nvim-autopairs")
            ap.setup {}
            ap.remove_rule("`")
            ap.remove_rule("(")
            ap.remove_rule("[")
            ap.remove_rule("{")
        end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "kdheepak/cmp-latex-symbols",
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({
                        select = false, -- Only confirm if explicitly selected
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- Add missing LSP source
                    { name = "nvim_lsp_signature_help" }, -- Shows function signature hints
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "vimtex" },
                    { name = "julials" },
                    {
                        name = "latex_symbols",
                        option = {
                            strategy = 0,
                        },
                    },
                }),
            })

            -- Set up LSP with nvim-cmp capabilities
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("lspconfig")["lua_ls"].setup({
                capabilities = capabilities,
            })
            require("lspconfig")["julials"].setup({
                capabilities = capabilities,
            })
            require("lspconfig")["pyright"].setup({ -- Ensure Python LSP is included
                capabilities = capabilities,
            })

            require("tex_snippets").setup()
            require("luasnip").config.setup({ enable_autosnippets = true })
        end,
    },
}
