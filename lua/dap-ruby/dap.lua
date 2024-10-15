local utils = require("dap-ruby.utils")

local M = {}

local dap = utils.load_module("dap")
dap.set_log_level("TRACE")

local default_configurations = {
	{
		type = "ruby",
		name = "*Debug script",
		request = "launch",
		localfs = true,
		command = utils.scope_command({ "ruby" }),
		script = "${file}",
	},
}

local default_adapter = function(configuration)
	local args = {}
	local invoking_command = configuration.command
	local invoking_script = configuration.script
	local adapter_command = utils.scope_command({ "rdbg" })
	local executable_command = adapter_command[1]

	if #adapter_command > 1 then
		vim.list_extend(args, { unpack(adapter_command, 2) })
	end

	vim.list_extend(args, { "--open", "--port", "${port}", "-c", "--" })
	vim.list_extend(args, invoking_command)
	vim.list_extend(args, { invoking_script })

	return {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = {
			command = executable_command,
			args = args,
		},
	}
end

M.build_ruby_configurations = function()
	dap.configurations.ruby = default_configurations
end

M.build_ruby_adapter = function()
	dap.adapters.ruby = function(callback, configuration)
		local adapter = default_adapter(configuration)
		-- vim.notify(vim.inspect(adapter))
		-- callback(adapter)

		vim.defer_fn(function()
			callback(adapter)
		end, 300)
	end
end

return M
