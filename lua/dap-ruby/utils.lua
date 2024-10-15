local M = {}

function M.load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dap-ruby dependency error: %s not installed", module_name))
	return module
end

function M.working_dir_has_bundle()
	local gemfile_path = vim.fn.getcwd() .. "/Gemfile"
	local bundle_exists = vim.fn.filereadable(gemfile_path) == 1

	return bundle_exists
end

function M.scope_command(command)
	if not type(command) == "table" then
		error("command must be table")
	end

	if M.working_dir_has_bundle() then
		local bundle_prefix = { "bundle", "exec" }
		return vim.list_extend(bundle_prefix, command)
	else
		return command
	end
end

return M
