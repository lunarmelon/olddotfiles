local config = function()
	local highlight = {
		"RainbowRed",
		"RainbowYellow",
		"RainbowBlue",
		"RainbowOrange",
		"RainbowGreen",
		"RainbowViolet",
		"RainbowCyan",
	}

	require("ibl").setup({
		indent = {
			highlight = highlight,
		},
		scope = { enabled = false },
	})

	local hooks = require("ibl.hooks")

	local mocha = require("catppuccin.palettes").get_palette("mocha")

	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = mocha.red })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = mocha.yellow })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = mocha.blue })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = mocha.orange })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = mocha.green })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = mocha.violet })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = mocha.cyan })
	end)
end

return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	config = config,
}
