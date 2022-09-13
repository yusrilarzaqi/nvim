local attach_to_buffer = function(output_bufrn, pattern, command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("Auto Runner", { clear = true }),
		pattern = pattern,
		callback = function()
			vim.api.nvim_buf_set_lines(output_bufrn, 0, -1, false, { "Output file of : " .. pattern })
			vim.api.nvim_buf_set_lines(output_bufrn, -1, -1, false, { "" })
			local append_data = function(_, data)
				if data then
					vim.api.nvim_buf_set_lines(output_bufrn, -1, -1, false, data)
				end
			end
			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = append_data,
				on_stderr = append_data,
			})
		end,
	})
end

--[[ attach_to_buffer(14, "*.py", { "python", "main.py" }) ]]

vim.api.nvim_create_user_command("AutoRun", function()
	print("AutoRun start now ...")
	local buffrn = vim.fn.input("Bufrn : ")
	local pattern = vim.fn.input("Pattern : ")
	local command = vim.split(vim.fn.input("Command : "), " ")
	attach_to_buffer(tonumber(buffrn), pattern, command)
end, {})