local utils = require("dap-ruby.utils")

local M = {}

local dap = utils.load_module("dap")

-- TODO: remove or implement via config
dap.set_log_level("DEBUG")

local default_configurations = {
	{
		type = "ruby",
		name = "Launch & Debug    |   Script",
		request = "launch",
		localfs = true,
		command = utils.scope_command({ "ruby" }),
		script = "${file}",
	},
	{
		type = "ruby",
		name = "Launch & Debug    |   Rails",
		request = "launch",
		localfs = true,
		command = utils.scope_command({ "rails", "server" }),
		rdbg_args = {
			"-n",
		},
	},
	{
		type = "ruby",
		name = "Attach & Debug    |   Rails",
		request = "attach",
		localfs = true,
	},
}

local default_adapter = function(configuration)
	local adapter = {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
	}

	if utils.is_table_empty(configuration.command) and configuration.request == "attach" then
		local port = utils.prompt_for_port()
		adapter.port = port
		return adapter
	end

	local args = {}
	local adapter_command = utils.scope_command({ "rdbg" })
	local invoking_command = configuration.command
	local invoking_script = configuration.script
	local invoking_arguments = configuration.args
	local executable_command = adapter_command[1]
	local executable_arguments = configuration.rdbg_args

	if #adapter_command > 1 then
		vim.list_extend(args, { unpack(adapter_command, 2) })
	end

	if not utils.is_table_empty(executable_arguments) then
		vim.list_extend(args, executable_arguments)
	end

	vim.list_extend(args, { "--open", "--port", "${port}", "-c", "--" })
	if invoking_command[1] == "bundle" and invoking_command[2] == "exec" and invoking_command[3] == "ruby" then
		vim.list_extend(args, invoking_command)
	else
		vim.list_extend(args, { table.concat(invoking_command, " ") })
	end

	if not utils.is_table_empty(invoking_arguments) then
		vim.list_extend(args, invoking_arguments)
	end

	vim.list_extend(args, { invoking_script })

	adapter.executable = { command = executable_command, args = args }

	return adapter
end

M.build_ruby_configurations = function()
	dap.configurations.ruby = default_configurations
end

M.build_ruby_adapter = function()
	dap.adapters.ruby = function(callback, configuration)
		local adapter = default_adapter(configuration)
		callback(adapter)

		-- vim.defer_fn(function()
		-- 	callback(adapter)
		-- end, 3000)
	end
end

return M
