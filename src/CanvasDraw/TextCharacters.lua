local Characters = {
	-- Numbers
	["0"] = {
		{1,1,1},
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,1,1},
	},
	["1"] = {
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,1,0},
	},
	["2"] = {
		{1,1,1},
		{0,0,1},
		{1,1,1},
		{1,0,0},
		{1,1,1},
	},
	["3"] = {
		{1,1,1},
		{0,0,1},
		{1,1,1},
		{0,0,1},
		{1,1,1},
	},
	["4"] = {
		{1,0,1},
		{1,0,1},
		{1,1,1},
		{0,0,1},
		{0,0,1},
	},
	["5"] = {
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{0,0,1},
		{1,1,1},
	},
	["6"] = {
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{1,0,1},
		{1,1,1},
	},
	["7"] = {
		{1,1,1},
		{0,0,1},
		{0,0,1},
		{0,0,1},
		{0,0,1},
	},
	["8"] = {
		{1,1,1},
		{1,0,1},
		{1,1,1},
		{1,0,1},
		{1,1,1},
	},
	["9"] = {
		{1,1,1},
		{1,0,1},
		{1,1,1},
		{0,0,1},
		{1,1,1},
	},
	
	-- Letters
	["a"] = {
		{1,1,1},
		{1,0,1},
		{1,1,1},
		{1,0,1},
		{1,0,1},
	},
	["b"] = {
		{1,1,0},
		{1,0,1},
		{1,1,1},
		{1,0,1},
		{1,1,1},
	},
	["c"] = {
		{1,1,1},
		{1,0,0},
		{1,0,0},
		{1,0,0},
		{1,1,1},
	},
	["d"] = {
		{1,1,0},
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,1,1},
	},
	["e"] = {
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{1,0,0},
		{1,1,1},
	},
	["f"] = {
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{1,0,0},
		{1,0,0},
	},
	["g"] = {
		{1,1,1},
		{1,0,0},
		{1,0,1},
		{1,0,1},
		{1,1,1},
	},
	["h"] = {
		{1,0,1},
		{1,0,1},
		{1,1,1},
		{1,0,1},
		{1,0,1},
	},
	["i"] = {
		{1,1,1},
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{1,1,1},
	},
	["j"] = {
		{0,0,1},
		{0,0,1},
		{0,0,1},
		{1,0,1},
		{1,1,1},
	},
	["k"] = {
		{1,0,1},
		{1,0,1},
		{1,1,0},
		{1,0,1},
		{1,0,1},
	},
	["l"] = {
		{1,0,0},
		{1,0,0},
		{1,0,0},
		{1,0,0},
		{1,1,1},
	},
	["m"] = {
		{1,0,1},
		{1,1,1},
		{1,1,1},
		{1,0,1},
		{1,0,1},
	},
	["n"] = {
		{1,1,1},
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,0,1},
	},
	["o"] = {
		{1,1,1},
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,1,1},
	},
	["p"] = {
		{1,1,1},
		{1,0,1},
		{1,1,1},
		{1,0,0},
		{1,0,0},
	},
	["q"] = {
		{1,1,1},
		{1,0,1},
		{1,0,1},
		{1,1,1},
		{0,1,0},
	},
	["r"] = {
		{1,1,1},
		{1,0,1},
		{1,1,0},
		{1,0,1},
		{1,0,1},
	},
	["s"] = {
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{0,0,1},
		{1,1,1},
	},
	["t"] = {
		{1,1,1},
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,1,0},
	},
	["u"] = {
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{1,1,1},
	},
	["v"] = {
		{1,0,1},
		{1,0,1},
		{1,0,1},
		{0,1,0},
		{0,1,0},
	},
	["w"] = {
		{1,0,1},
		{1,0,1},
		{1,1,1},
		{1,1,1},
		{1,0,1},
	},
	["x"] = {
		{1,0,1},
		{1,0,1},
		{0,1,0},
		{1,0,1},
		{1,0,1},
	},
	["y"] = {
		{1,0,1},
		{1,0,1},
		{1,1,1},
		{0,1,0},
		{0,1,0},
	},
	["z"] = {
		{1,1,1},
		{0,0,1},
		{0,1,0},
		{1,0,0},
		{1,1,1},
	},
	
	-- Symbols
	["!"] = {
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,0,0},
		{0,1,0},
	},
	["@"] = {
		{1,1,0},
		{0,0,1},
		{1,1,1},
		{1,0,1},
		{1,1,0},
	},
	["#"] = {
		{1,0,1},
		{1,1,1},
		{1,0,1},
		{1,1,1},
		{1,0,1},
	},
	["$"] = {
		{0,1,0},
		{1,1,1},
		{1,0,0},
		{1,1,1},
		{0,1,0},
	},
	["%"] = {
		{1,0,1},
		{0,0,1},
		{0,1,0},
		{1,0,0},
		{1,0,1},
	},
	["^"] = {
		{0,1,0},
		{1,0,1},
		{0,0,0},
		{0,0,0},
		{0,0,0},
	},
	["&"] = {
		{0,1,0},
		{1,0,1},
		{0,1,0},
		{1,0,1},
		{1,1,1},
	},
	["*"] = {
		{1,0,1},
		{0,1,0},
		{1,0,1},
		{0,0,0},
		{0,0,0},
	},
	["("] = {
		{0,1,1},
		{1,0,0},
		{1,0,0},
		{1,0,0},
		{0,1,1},
	},
	[")"] = {
		{1,1,0},
		{0,0,1},
		{0,0,1},
		{0,0,1},
		{1,1,0},
	},
	["["] = {
		{1,1,1},
		{1,0,0},
		{1,0,0},
		{1,0,0},
		{1,1,1},
	},
	["]"] = {
		{1,1,1},
		{0,0,1},
		{0,0,1},
		{0,0,1},
		{1,1,1},
	},
	["{"] = {
		{0,1,1},
		{0,1,0},
		{1,1,0},
		{0,1,0},
		{0,1,1},
	},
	["}"] = {
		{1,1,0},
		{0,1,0},
		{0,1,1},
		{0,1,0},
		{1,1,0},
	},
	["-"] = {
		{0,0,0},
		{0,0,0},
		{1,1,1},
		{0,0,0},
		{0,0,0},
	},
	["_"] = {
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{1,1,1},
	},
	["+"] = {
		{0,0,0},
		{0,1,0},
		{1,1,1},
		{0,1,0},
		{0,0,0},
	},
	["="] = {
		{0,0,0},
		{1,1,1},
		{0,0,0},
		{1,1,1},
		{0,0,0},
	},
	["<"] = {
		{0,0,1},
		{0,1,0},
		{1,0,0},
		{0,1,0},
		{0,0,1},
	},
	[">"] = {
		{1,0,0},
		{0,1,0},
		{0,0,1},
		{0,1,0},
		{1,0,0},
	},
	["?"] = {
		{1,1,0},
		{0,0,1},
		{0,1,0},
		{0,0,0},
		{0,1,0},
	},
	["."] = {
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,1,0},
	},
	[","] = {
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,1,0},
		{0,1,0},
	},
	["/"] = {
		{0,0,1},
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{1,0,0},
	},
	["|"] = {
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,1,0},
		{0,1,0},
	},
	[":"] = {
		{1,0,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{1,0,0},
	},
	[";"] = {
		{1,0,0},
		{0,0,0},
		{0,0,0},
		{1,0,0},
		{1,0,0},
	},
	['"'] = {
		{1,0,1},
		{1,0,1},
		{0,0,0},
		{0,0,0},
		{0,0,0},
	},
	["'"] = {
		{0,1,0},
		{0,1,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
	},
	["`"] = {
		{1,0,0},
		{0,1,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
	},
	["~"] = {
		{0,0,0},
		{1,1,0},
		{0,1,1},
		{0,0,0},
		{0,0,0},
	},
	[" "] = {
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
		{0,0,0},
	},
}

return Characters
