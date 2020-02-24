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
        restart: :temporary,
        start: {Tl.Cmd, :start_link, ["/usr/bin/redshift", []]}
      },
      %{id: :sxhkd, start: {Tl.Cmd, :start_link, ["/usr/bin/sxhkd", []]}},
      %{id: :kitty, start: {Tl.Cmd, :start_link, ["/usr/bin/kitty", []]}, restart: :temporary},
      %{
        id: :chrome,
        start: {Tl.Cmd, :start_link, ["/usr/bin/google-chrome-stable", []]},
        restart: :temporary
      },
      %{id: :brave, start: {Tl.Cmd, :start_link, ["/usr/bin/brave", []]}, restart: :temporary},
      %{
        id: :xset,
        start: {Tl.Cmd, :start_link, ["/usr/bin/xset", ["r", "rate", "200", "30"]]},
        restart: :temporary
      },
      %{
        id: :rescuetime,
        start: {Tl.Cmd, :start_link, ["/usr/bin/rescuetime", []]},
        restart: :temporary
      },
      %{
        id: :slack,
        start: {Tl.Cmd, :start_link, ["/usr/bin/slack", []]},
        restart: :temporary
      },
      %{
        id: :pcloud,
        start: {Tl.Cmd, :start_link, ["/usr/bin/pcloud", []]},
        restart: :temporary
      },

      %{
        id: :xcape,
        start: {Tl.Cmd, :start_link, ["/usr/bin/xcape", ["-t", "200", "-e", "Control_L=Escape"]]},
        restart: :temporary
      },

      %{
        id: :feh,
        start: {Tl.Cmd, :start_link, ["/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")]]},
        restart: :temporary
      },
      worker(Tl.ClosedWatcher, [
        [
          fs_args: [dirs: [board()], name: :board_monitor],
          call_mod: Tl.Taskell.SplitColumns
        ]
      ]),
      Tl.Scheduler
    ] ++ machine_specific_workers()
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
