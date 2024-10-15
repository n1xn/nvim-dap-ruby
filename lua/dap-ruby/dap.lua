local utils = require("dap-ruby.utils")

local M = {}

local dap = utils.load_module("dap")
dap.set_log_level("TRACE")

local configuration_command = utils.working_dir_has_bundle() and "bundle" or "ruby"

local default_configurations = {
	{
		type = "ruby",
		name = "*Debug script",
		request = "launch",
		localfs = true,
		command = configuration_command,
		args = {
			"ruby",
		},
		script = "${file}",
	},
}

local default_adapter = function(configuration)
	local executable_command = "rdbg"
	local executable_arguments = {}
	local invoked_command = { configuration_command }

	if utils.working_dir_has_bundle() then
		executable_command = "bundle"
		executable_arguments = { "exec", "rdbg" }
		invoked_command = { "bundle", "exec" }
		invoked_command = vim.list_extend(invoked_command, configuration.args)
	end

	local args = vim.list_extend(executable_arguments, {
		"--open",
		"--port",
		"${port}",
		"-c",
		"--",
	})

	args = vim.list_extend(args, invoked_command)
	args = vim.list_extend(args, { configuration.script })

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

M.build_ruby_configurations = function(custom_configurations)
	dap.configurations.ruby = default_configurations
end

M.build_ruby_adapter = function(custom_adapter)
	dap.adapters.ruby = function(callback, configuration)
		local adapter = default_adapter(configuration)
		vim.notify(vim.inspect(adapter))
		-- callback(adapter)

		vim.defer_fn(function()
			callback(adapter)
		end, 300)
	end
end

return M
