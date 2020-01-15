defmodule Tl.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # This is the new line
      Tl.Scheduler,
      Tl.Cmd.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Tl.Application]
    Supervisor.start_link(children, opts)
  end
end
