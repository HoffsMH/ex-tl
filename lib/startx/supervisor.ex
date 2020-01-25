defmodule Tl.Startx.Supervisor do
  use Supervisor

  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Tl.Cmd, ["/usr/bin/redshift", []], id: :redshift),
      # worker(Tl.Cmd, ["/usr/bin/clipmenud", []], id: :clipmenud),
      worker(Tl.Cmd, ["/usr/bin/sxhkd", []], id: :sxhkd),
      worker(Tl.Watcher, [[dirs: [board()], name: :board_monitor]]),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
