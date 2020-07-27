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
      %{
        id: :pcloud,
        start: {Tl.Cmd, :start_link, ["/usr/bin/pcloud", []]}
      },
      %{
        id: :xcape,
        start: {Tl.Cmd, :start_link, ["/usr/bin/xcape", ["-t", "200", "-e", "Control_L=Escape"]]},
        restart: :transient
      },
      %{
        id: :greenclip,
        start: {Tl.Cmd, :start_link, ["/usr/bin/greenclip", ["daemon"]]},
        restart: :transient
      },
      %{
        id: :polybar,
        start: {Tl.Cmd, :start_link, ["/usr/bin/polybar", ["-c", Path.expand("~/.config/polybar/config/polybarconfig"), "main"]]},
        restart: :transient
      },
      %{
        id: :restic_backup,
        start:
          {Tl.Cmd, :start_link,
           [
             "/usr/bin/restic",
             [
               "backup",
               "--verbose",
               "--tag",
               "systemd.timer",
               "--exclude-file=/home/hoffs/.restic_excludes",
               "/home/hoffs/"
             ]
           ]},
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
