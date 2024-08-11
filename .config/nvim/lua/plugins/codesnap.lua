local config = function()
	require("codesnap").setup({
		code_font_family = "JetBrainsMono Nerd Font",
		watermark = "",
		has_breadcrumbs = true,
		-- has_line_number = true,
	})
end

return {
	"mistricky/codesnap.nvim",
	lazy = false,
	build = "make",
	config = config,
}
