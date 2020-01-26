defmodule Tl.Startx.RunOnce do
  def config_cmds() , do: Application.get_env(:tl, :run_once)

  def call(_args), do: call()
  def call() do
    Tl.Cmd.exec([
      {"xset", ["r", "rate", "200", "30"]},
      {"/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")]},
      {"xcape", ["-t", "200", "-e", "Control_L=Escape"]}
    ] ++ config_cmds())

      # 'xset r rate 200 30',
      # 'feh --bg-scale ~/.wall.jpg',
      # 'xcape -t 200 -e Control_L=Escape',

      # {"xset", ["r", "rate", "200", "30"]},
      # {"/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")]},
      # {"xcape", ["-t", "200", "-e", "Control_L=Escape"]}
  end
end
