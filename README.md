# nvim-dap-ruby

## Known issues

### Rails

Running `Launch & Debug   |   Rails` requires the LSP to be fully loaded
before a breakpoint can be triggered.

Sometimes DAP notifes about `Error retrieving stack traces: Failed`
and you have to hit your breakpoint multiple times before it actually triggers.
