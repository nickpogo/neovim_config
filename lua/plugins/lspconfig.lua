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
				ensure_installed = { "lua_ls", "ltex", "julials", "pyright" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.signatureHelp = {
				dynamicRegistration = false,
				signatureInformation = {
					documentationFormat = { "markdown", "plaintext" },
					parameterInformation = { labelOffsetSupport = true },
				},
			}

			local lspconfig = require("lspconfig")

			-- 🌟 GLOBAL KEY BINDINGS (Always Available)
			vim.keymap.set(
				"n",
				"<leader>ca",
				vim.lsp.buf.code_action,
				{ noremap = true, silent = true, desc = "Code Actions" }
			)
			vim.keymap.set("n", "<leader>cp", function()
				vim.lsp.buf.format({ async = true })
			end, { noremap = true, silent = true, desc = "Code Prettify" })

			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { noremap = true, silent = true })

			-- 🌟 LSP-SPECIFIC ON_ATTACH FUNCTION
			local on_attach = function(client, bufnr)
				local opts_ca = { buffer = bufnr, noremap = true, silent = true, desc = "Code Actions"  }
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts_ca)


				local opts_cp = { buffer = bufnr, noremap = true, silent = true, desc = "Code Prettify" }
				vim.keymap.set("n", "<leader>cp", function()
					vim.lsp.buf.format({ async = true })
				end, opts_cp)
			end

			-- 🌟 LSP CONFIGURATIONS
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.ltex.setup({
				settings = {
					ltex = { language = "en-US" },
				},
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.julials.setup({
				cmd = {
					"julia",
					"--startup-file=no",
					"--history-file=no",
					"-e",
					[[
                    using LanguageServer; using Pkg;
                    import SymbolServer;
                    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
                    project_path = let
                        dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
                    end
                    server = LanguageServer.LanguageServerInstance(stdin, stdout, depot_path, project_path, nothing)
                    server.runlinter = true
                    run(server)
                ]],
				},
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},
}
