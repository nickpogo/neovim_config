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
			vim.cmd("set conceallevel=0")
			vim.g.tex_conceal = "abdmg"
		end,
	},
	{
		"micangl/cmp-vimtex",
	},
	-- {
	--   "bamonroe/rnoweb-nvim",
	--   config = function()
	--     require('rnoweb-nvim').setup()
	--
	--     -- Set some of my own symbols that are likely not in anyone else's docs
	--     local sym = require('rnoweb-nvim.symbols')
	--     sym.set_sym("latex", "\\gi",    {"g⁻¹"})
	--     sym.set_sym("latex", "\\@",     {""})
	--     sym.set_sym("latex", '\\CE',    {"CE"})
	--     sym.set_sym("latex", '\\CS',    {"ECS"})
	--     sym.set_sym("latex", '\\Pr',    {"Pr"})
	--     sym.set_sym("latex", '\\pr',    {"Pr(", ")"})
	--     sym.set_sym("latex", "\\email", {"✉ :", ""})
	--     sym.set_sym("latex", "\\gbar",  {"(",   " ︳", ")"})
	--     sym.set_sym("latex", "\\gbar*", {"",    " ︳", ""})
	--   end
	-- }
}
