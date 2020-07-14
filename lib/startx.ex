defmodule Tl.Startx do
  def call(_args), do: call()

  def call() do
    log("startx.call has been called!")

    log("run once")

    Tl.Cmd.start("/usr/bin/kitty")
    Tl.Cmd.start("/usr/bin/brave")
    Tl.Cmd.start("/usr/bin/slack")
    Tl.Cmd.start("/usr/bin/google-chrome-stable")
    Tl.Cmd.exec("/usr/bin/feh", ["--bg-scale", Path.expand("~/.wall.jpg")])

    log("starting long running commands")
    Tl.Startx.Supervisor.start_link(name: Tl.Startx.Supervisor)

    receive do
      {:DOWN, _, _, _, _} ->
        IO.puts("Startx is down")
    end
  end

  def log(text) do
    Tl.log("startx", text)
  end
end
