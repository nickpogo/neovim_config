return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_quickfix_mode = 0

			vim.g.vimtex_syntax_conceal = {
				accents = 1,
				ligatures = 1,
				cites = 1,
				fancy = 1,
				greek = 1,
				math = 1,
				subscripts = 1,
				superscripts = 1,
				fractions = 1,
			}
			vim.opt.conceallevel = 2
			vim.opt.concealcursor = "nc"

			-- vim.cmd("set conceallevel=0")
			-- vim.g.tex_conceal = "abdmg"

			-- Load ChatGPT utilities
			local chatgpt_utils = require("chatgpt_utils") -- Adjust the path

			-- Set keymaps only for LaTeX files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function()
					local opts = { noremap = true, silent = true, buffer = true, desc = "Check grammar" }

					vim.keymap.set("v", "<leader>gc", function()
						chatgpt_utils.check_grammar()
					end, opts)

					vim.keymap.set("n", "<leader>ct", "<cmd>Telescope thesaurus lookup<CR>")
				end,
			})
		end,
	},
	{
		"micangl/cmp-vimtex",
	},
}
