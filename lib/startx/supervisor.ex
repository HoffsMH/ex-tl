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
      worker(Tl.Cmd, ["/usr/bin/clipmenud", []], id: :clipmenud),
      worker(Tl.Cmd, ["/usr/bin/sxhkd", []], id: :sxhkd),
      worker(Tl.Cmd, ["/usr/bin/kitty", []], id: :kitty, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/google-chrome-stable", []], id: :chrome, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/firefox", []], id: :firefox, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/slack", []], id: :slack, restart: :temporary),
      worker(Tl.ClosedWatcher, [[
        fs_args: [dirs: [board()], name: :board_monitor],
        call_mod: Tl.Taskell.SplitColumns
      ]]),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
