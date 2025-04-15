return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({
			preview = {
				icon_provider = "devicons",
			},
		})
	end,
}
