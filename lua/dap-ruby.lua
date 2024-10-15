local dap = require("dap-ruby.dap")

local M = {}

function M.setup(opts)
	dap.build_ruby_adapter()
	dap.build_ruby_configurations()
end

return M
