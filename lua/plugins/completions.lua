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
	-- {
	-- 	"iurimateus/luasnip-latex-snippets.nvim",
	-- 	dependencies = {
	-- 		"L3MON4D3/LuaSnip",
	-- 		-- "lervag/vimtex",
	-- 	},
	-- 	config = function()
	-- 		require("luasnip-latex-snippets").setup({ use_treesitter = true })
	-- 		-- or setup({ use_treesitter = true })
	-- 		require("luasnip").config.setup({ enable_autosnippets = true })
	-- 	end,
	-- },
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
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						elseif cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- ["<C-j>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_next_item()
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
					--
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_prev_item()
					-- 	elseif luasnip.locally_jumpable(-1) then
					-- 		luasnip.jump(-1)
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "vimtex" },
					{ name = "julials" },
					{
						name = "latex_symbols",
						option = {
							strategy = 0, -- mixed
						},
					},
					-- {
					-- 	name = "omni",
					-- 	option = {
					-- 		disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
					-- 	},
					-- },
				}),
			})

			-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline({ "/", "?" }, {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = {
			-- 		{ name = "buffer" },
			-- 	},
			-- })
			--
			-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline(":", {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = cmp.config.sources({
			-- 		{ name = "path" },
			-- 	}, {
			-- 		{ name = "cmdline" },
			-- 	}),
			-- 	matching = { disallow_symbol_nonprefix_matching = false },
			-- })

			-- Set up lspconfig.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("lspconfig")["lua_ls"].setup({
				capabilities = capabilities,
			})
			require("lspconfig")["julials"].setup({
				capabilities = capabilities,
			})

			require("tex_snippets").setup()
			require("luasnip").config.setup({ enable_autosnippets = true })
		end,
	},
}
