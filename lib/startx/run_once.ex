defmodule Tl.Startx.RunOnce do
  def config_cmds(), do: Application.get_env(:tl, :run_once, [])
  def machine_specific_cmds(), do: Application.get_env(:tl, :machine_specific_run_once, [])

  def call(_args), do: call()

  def call() do
    log("run_once has been called")
    log("here are the cmds from config")
    log("#{config_cmds() |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.at(&1, 0))}")

    Tl.Cmd.exec(
      [
        {"xset", ["r", "rate", "200", "30"]},
        {"/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")]},
        {"xcape", ["-t", "200", "-e", "Control_L=Escape"]}
      ] ++ config_cmds() ++ machine_specific_cmds()
    )
  end

  def log(text) do
    Tl.log("run_once", text)
  end
end
