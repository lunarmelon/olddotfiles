return {
	"RRethy/vim-illuminate",
	lazy = false,
	config = function()
		require("illuminate").configure({
			filetypes_denylist = {
				"dirbuf",
				"drivish",
				"fugitive",
				"json",
				"jsonc",
				"toml",
				"yaml",
			},
		})
	end,
}
