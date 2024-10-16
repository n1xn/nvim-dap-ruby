# nvim-dap-ruby

The goal of this library is to have a better out of the box experience using ruby
with nvim. This library does not try to give you default configurations for all
of your possible commands, ruther to give you a good point of reference.

If you need a more comprehensive solution please refere to [nvim-dap-ruby](https://github.com/suketa/nvim-dap-ruby)
instead.

## Motivation

I was not able to debug minitests with neotest neither was I able to successfully
debug rails with all existing adapters and while I was learning nvim I decided to
create my own.

The strengths of this adapter is that it executes the configurations dynamically,
based on your context. You can debug single ruby scripts and bundled applications like
rails and minitests.

## Requirements

- [LazyVim](https://www.lazyvim.org/)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [ruby/debug](https://github.com/ruby/debug)
- [optional: nvim-dap-ruby](https://github.com/n1xn/nvim-dap-ruby)

Update your plugin configuration to include the repo and run the setup method.

```lua
return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = {
    {
      "n1xn/nvim-dap-ruby",
    },
  },
  opts = function(_, opts)
    require("dap-ruby").setup()
  end,
}

```

Update your `Procfile.dev` and your `bin/dev` scripts so that the debugger can attach
to.

Procfile.dev

```
web: bundle exec rdbg -c -- bin/rails server -b ${HOST_NAME} -p ${RAILS_PORT}
css: bin/rails tailwindcss:watch

```

bin/dev

```
#!/usr/bin/env sh

export RAILS_PORT="${RAILS_PORT:-3000}"

export RUBY_DEBUG_OPEN="${RUBY_DEBUG_OPEN:-true}"
export RUBY_DEBUG_LAZY="${RUBY_DEBUG_LAZY:-true}"
export RUBY_DEBUG_NONSTOP="${RUBY_DEBUG_NONSTOP:-true}"

export RUBY_DEBUG_HOST="${RUBY_DEBUG_HOST:-127.0.0.1}"
export RUBY_DEBUG_PORT="${RUBY_DEBUG_PORT:-33333}"

exec foreman start -f Procfile "$@"

```

## How to

### ruby on rails

> [!IMPORTANT]
> Whenever you are running a command you want to debug, [rdbg](https://github.com/ruby/debug)
> must be called beforehand so the debugger can attach to to process.
>
> Usually the debugger will inform you about the port which you can attach to:
> `DEBUGGER: Debugger can attach via TCP/IP (127.0.0.1:33333)`
