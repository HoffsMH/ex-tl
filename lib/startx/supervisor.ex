defmodule Tl.Startx.Supervisor do
  use Supervisor

  def machine_specific_workers() do
    Application.get_env(:tl, :machine_specific_workers, [])
  end

  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  def children() do
    [
      %{
        id: :redshift,
        start: {Tl.Cmd, :start_link, ["/usr/bin/redshift", []]}
      },
      %{id: :sxhkd, start: {Tl.Cmd, :start_link, ["/usr/bin/sxhkd", []]}},
      %{
        id: :xset,
        start: {Tl.Cmd, :start_link, ["/usr/bin/xset", ["r", "rate", "200", "30"]]},
        restart: :transient
      },
      %{
        id: :rescuetime,
        start: {Tl.Cmd, :start_link, ["/usr/bin/rescuetime", []]}
      },

      Tl.Scheduler
    ] ++ machine_specific_workers()
  end
end
