return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local dashboard = require("alpha.themes.dashboard")

		local neovim_logo = {
			"                                                    ",
			" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                    ",
		}

		dashboard.section.header.val = neovim_logo

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", "<cmd>ene<CR>"),
			dashboard.button("SPC f f", "  Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("m", "󱌣  Mason", "<cmd>Mason<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}
		return dashboard
	end,
	config = function(_, dashboard)
		local alpha = require("alpha")

		vim.api.nvim_create_autocmd("User", {
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100
				dashboard.section.footer.val = "󱐌 Lazy-loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
		alpha.setup(dashboard.opts)
	end,
}
