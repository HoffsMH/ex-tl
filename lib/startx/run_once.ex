defmodule Tl.Startx.RunOnce do
  def call(_args), do: call()

  def call() do
    Tl.Cmd.exec([
      'xset r rate 200 30',
      'feh --bg-scale ~/.wall.jpg',
      'xcape -t 200 -e Control_L=Escape',
      '~/.test_script.sh'
    ])

      # {"xset", ["r", "rate", "200", "30"]},
      # {"/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")]},
      # {"xcape", ["-t", "200", "-e", "Control_L=Escape"]}
  end
end
