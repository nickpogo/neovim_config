local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local ts = require("ts_utils")
local extras = require("luasnip.extras")
local rep = extras.rep
local line_begin = require("luasnip.extras.conditions.expand").line_begin

local function array_concat(...)
	local tt = {}
	for n = 1, select("#", ...) do
		local arg = select(n, ...)
		if type(arg) == "table" then
			for _, v in ipairs(arg) do
				tt[#tt + 1] = v
			end
		else
			tt[#tt + 1] = arg
		end
	end
	return tt
end

-- use two conditions at once
local env_condition = line_begin * ts.in_text -- ts.pipe { line_begin, ts.in_text }

-- this can be used without treesitter
--
-- local function is_math()
--   return vim.api.nvim_eval 'vimtex#syntax#in_mathzone()' == 1
-- end

local greek = {
	s("`a", {
		t("\\alpha"),
	}, { condition = ts.in_mathzone, show_condition = false }),
	s("`b", {
		t("\\beta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`g", {
		t("\\gamma"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`G", {
		t("\\Gamma"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`d", {
		t("\\delta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`D", {
		t("\\Delta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`e", {
		t("\\epsilon"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`z", {
		t("\\zeta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`y", {
		t("\\eta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`q", {
		t("\\theta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`Q", {
		t("\\theta"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`i", {
		t("\\iota"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`k", {
		t("\\kappa"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`l", {
		t("\\lambda"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`L", {
		t("\\Lambda"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`m", {
		t("\\mu"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`n", {
		t("\\nu"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`x", {
		t("\\xi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`p", {
		t("\\pi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`r", {
		t("\\rho"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`s", {
		t("\\sigma"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`S", {
		t("\\Sigma"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`t", {
		t("\\tau"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`u", {
		t("\\upsilon"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`f", {
		t("\\phi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`vf", {
		t("\\varphi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`c", {
		t("\\chi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`w", {
		t("\\psi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`W", {
		t("\\Psi"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`o", {
		t("\\omega"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`O", {
		t("\\Omega"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`\\", {
		t("\\setminus"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`8", {
		t("\\infty"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
}

local doubles = {
	s("NN", {
		t("\\mathbb{N}"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("ZZ", {
		t("\\mathbb{Z}"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("QQ", {
		t("\\mathbb{Q}"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("RR", {
		t("\\mathbb{R}"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("CC", {
		t("\\mathbb{C}"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("OO", {
		t("\\varnothing"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("AA", {
		t("\\forall"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("EE", {
		t("\\exists"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("dd", {
		t("\\partial"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("DD", {
		t("\\nabla"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
}

local environments = {
	s(
		{ trig = "ali", name = "Align" },
		{ t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) },
		{ condition = env_condition, show_condition = env_condition }
	),
	s(
		{ trig = "gat", name = "Gather" },
		{ t({ "\\begin{gather*}", "\t" }), i(1), t({ "", "\\end{gather*}" }) },
		{ condition = env_condition, show_condition = env_condition }
	),
	s(
		{ trig = "mln", name = "Multline" },
		{ t({ "\\begin{multline*}", "\t" }), i(1), t({ "", "\\end{multline*}" }) },
		{ condition = env_condition, show_condition = env_condition }
	),
}

local backslash = {
	s("sin", {
		t("\\sin"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("cos", {
		t("\\cos"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("tan", {
		t("\\tan"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("exp", {
		t("\\exp"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("log", {
		t("\\log"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("int", {
		t("\\int"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("sum", {
		t("\\sum"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("max", {
		t("\\max"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("min", {
		t("\\min"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
}

local operators = {
	-- s('^', {
	--   t '^{',
	-- }, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	-- s('_', {
	--   t '_{',
	-- }, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("~~", {
		t("\\sim"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("~=", {
		t("\\approx"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("-~", {
		t("\\backsimeq"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("=>", {
		t("\\implies"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("<=", {
		t("\\impliedby"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("::", {
		t("\\colon"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("-~", {
		t("\\backsimeq"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("->", {
		t("\\to"),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("mto", {
		t("\\mapsto"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("tto", {
		t("\\rightrightarrows"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("lll", {
		t("\\ell"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("iff", {
		t("\\iff"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("xx", {
		t("\\times"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("oxx", {
		t("\\otimes"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("qq", {
		t("\\quad"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("cc", {
		t("\\subset"),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
}

local fonts = {
	s("mcc", {
		t("\\mathcal{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("mff", {
		t("\\mathfrac{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("mbb", {
		t("\\mathbb{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("mss", {
		t("\\mathscr{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("bf", {
		t("\\mathbf{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("hat", {
		t("\\hat{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("bar", {
		t("\\bar{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("ovr", {
		t("\\overline{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
	s("tld", {
		t("\\tilda{"),
		i(1),
		t("}"),
		i(0),
	}, {
		condition = function(line_to_cursor, matched_trigger, captures)
			return ts.in_mathzone() and ts.no_backslash(line_to_cursor)
		end,
	}),
}

local parenthesis = {
	s("`(", {
		t("\\left("),
		i(1),
		t("\\right)"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`[", {
		t("\\left["),
		i(1),
		t("\\right]"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("[[", {
		t("\\left\\{"),
		i(1),
		t("\\right\\}"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`<", {
		t("\\left<"),
		i(1),
		t("\\right>"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("||", {
		t("\\left\\|"),
		i(1),
		t("\\right\\|"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
	s("`|", {
		t("\\left|"),
		i(1),
		t("\\right|"),
		i(0),
	}, { condition = ts.in_mathzone, show_condition = ts.in_mathzone }),
}

local tex_only = {
	s(
		{ trig = "mk", name = "inline" },
		{ t("\\( "), i(1), t(" \\)"), i(0) },
		{ condition = ts.in_text, show_condition = ts.in_text }
	),
	s(
		{ trig = "dm", name = "math" },
		{ t({ "\\[", "\t" }), i(1), t({ "", "\\]" }), i(0) },
		{ condition = env_condition, show_condition = env_condition }
	),
}

local md_only = {
	s(
		{ trig = "mk", name = "inline" },
		{ t("$"), i(1), t("$"), i(0) },
		{ condition = ts.in_text, show_condition = ts.in_text }
	),
	s(
		{ trig = "dm", name = "math" },
		{ t({ "$$", "\t" }), i(1), t({ "", "$$" }), i(0) },
		{ condition = env_condition, show_condition = env_condition }
	),
}

local common_list = array_concat(greek, fonts, doubles, operators, backslash, parenthesis, { block_math })
local tex_list = array_concat(common_list, environments, tex_only)
local md_list = array_concat(common_list, md_only)

-- no we add everythin to neovim

N = {}

function N.setup()
	-- this is very important!!!
	require("luasnip").config.setup({ enable_autosnippets = true })

	ls.add_snippets("tex", tex_list, {
		type = "autosnippets",
	})

	ls.add_snippets("markdown", md_list, {
		type = "autosnippets",
	})
end

return N
