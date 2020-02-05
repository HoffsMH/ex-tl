defmodule Tl.Startx.SupervisorTest do
  use ExUnit.Case

  test "#children" do
    assert Tl.Startx.Supervisor.children() == [
             %{
               id: :redshift,
               restart: :temporary,
               start: {Tl.Cmd, :start_link, ["/usr/bin/redshift", []]}
             },
             %{id: :sxhkd, start: {Tl.Cmd, :start_link, ["/usr/bin/sxhkd", []]}},
             %{id: :kitty, start: {Tl.Cmd, :start_link, ["/usr/bin/kitty", []]}, restart: :temporary},
             %{id: :chrome, start: {Tl.Cmd, :start_link, ["/usr/bin/google-chrome-stable", []]}, restart: :temporary},
             %{id: :brave, start: {Tl.Cmd, :start_link, ["/usr/bin/brave", []]}, restart: :temporary},
             {:rescuetime, {Tl.Cmd, :start_link, ["/usr/bin/rescuetime", []]}, :temporary, 5000,
              :worker, [Tl.Cmd]},
             {:slack, {Tl.Cmd, :start_link, ["/usr/bin/slack", []]}, :temporary, 5000, :worker,
              [Tl.Cmd]},
             {:pcloud_1, {Tl.Cmd, :start_link, ["/usr/bin/pcloud", []]}, :temporary, 5000,
              :worker, [Tl.Cmd]},
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
               ]}, :permanent, 5000, :worker, [Tl.ClosedWatcher]}
           ]
  end
end
