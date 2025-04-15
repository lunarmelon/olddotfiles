return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
	},
	lazy = false,
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		filesystem = {
			follow_current_file = { enabled = true },
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				never_show = {
					".DS_Store",
					"thumbs.db",
				},
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					added = "",
					deleted = "",
					modified = "",
					renamed = "➜",
					untracked = "",
					ignored = "◌",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
				},
			},
		},
	},
}
