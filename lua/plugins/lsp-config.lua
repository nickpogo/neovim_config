return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ltex", "julials" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({})

			lspconfig.ltex.setup({
				settings = {
					ltex = {
						language = "en-US",
						additionalRules = {
							languageModel = "~/Programs/ngrams/ngrams-en-20150817/",
						},
					},
				},
			})

			lspconfig.julials.setup({
				capabilities = capabilities,
			})

			-- Mappings.
			local opts = { buffer = bufnr, noremap = true, silent = true }
			-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end,
	},
}
