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
    children = [
      %{
        id: :redshift,
        restart: :temporary,
        start: {Tl.Cmd, :start_link, ["/usr/bin/redshift", []]}
      },
      %{
        id: :sxhkd,
        start: {Tl.Cmd, :start_link, ["/usr/bin/sxhkd", []]}
      },

      worker(Tl.Cmd, ["/usr/bin/kitty", []], id: :kitty, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/google-chrome-stable", []], id: :chrome, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/brave", []], id: :brave, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/rescuetime", []], id: :rescuetime, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/slack", []], id: :slack, restart: :temporary),
      worker(Tl.Cmd, ["/usr/bin/pcloud", []], id: :pcloud_1, restart: :temporary),
      worker(Tl.ClosedWatcher, [
        [
          fs_args: [dirs: [board()], name: :board_monitor],
          call_mod: Tl.Taskell.SplitColumns
        ]
      ])
    ] ++ machine_specific_workers()

    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_polybar_monitors() do
    {output, 0} = Tl.Cmd.exec("polybar", ["--list-monitors"])

    output
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&Enum.at(&1, 0))
  end

  def poly_bar_child_specs() do
    get_polybar_monitors()
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&monitor_name_to_spec/1)
  end

  def monitor_name_to_spec(name) do
    %{
      id: String.to_atom("polybar_#{name}"),
      start: {Tl.OsCmd, :start_link, ["MONITOR=#{name} /usr/bin/polybar --reload main"]}
    }
  end
end
