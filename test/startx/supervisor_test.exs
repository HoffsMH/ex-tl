defmodule Tl.Startx.SupervisorTest do
  use ExUnit.Case

  test "#children" do
    assert Tl.Startx.Supervisor.children() == [
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
               start:
                 {Tl.Cmd, :start_link,
                  ["/usr/bin/xcape", ["-t", "200", "-e", "Control_L=Escape"]]},
               restart: :transient
             },
             %{
               id: :greenclip,
               start: {Tl.Cmd, :start_link, ["/usr/bin/greenclip", ["daemon"]]},
               restart: :transient
             },
             {Tl.ClosedWatcher,
              {Tl.ClosedWatcher, :start_link,
               [
                 [
                   fs_args: [
                     dirs: ["/home/hoffs/personal/01-schedule/board/taskell.md"],
                     name: :board_monitor
                   ],
                   call_mod: Tl.Taskell.SplitColumns
                 ]
               ]}, :permanent, 5000, :worker, [Tl.ClosedWatcher]},
             Tl.Scheduler
           ]
  end
end
