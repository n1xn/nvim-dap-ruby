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

-- prefixes commands with "bundle exec" if a Gemfile is present
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

-- checks if a table is empty, considering { "" } also as empty
function M.is_table_empty(table)
	return not (table and #table > 0 and vim.fn.index(table, "") == -1)
end

local function is_port_available(port, host)
	host = host or "127.0.0.1"
	local socket = vim.loop.new_tcp()
	local is_available = socket:bind(host, port)
	socket:close()
	return is_available
end

function M.available_random_port(attempt)
	local attempts = attempt or 1
	local max_attempts = 5

	if attempts > max_attempts then
		error("Could not find an available port after 5 attempts")
	end

	local random_port = math.random(1024, 65535)

	if is_port_available(random_port) then
		return random_port
	else
		return M.available_random_port(attempts + 1)
	end
end

function M.prompt_for_port()
	local port = vim.fn.input("Enter the port of the already running debugging process:")

	if tonumber(port) and tonumber(port) > 0 and tonumber(port) <= 65535 then
		return tonumber(port)
	else
		error("Invalid port number. Please enter a number between 1024 and 65535.")
	end
end

return M
