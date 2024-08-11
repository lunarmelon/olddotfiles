local function show_path()
	local current_path = vim.fn.expand("%:p")
	print("Current path: " .. current_path)
end

vim.api.nvim_create_user_command("ShowPath", show_path, { nargs = "?" })
