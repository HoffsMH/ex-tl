defmodule Tl.Startx do
  def call(_args), do: call()

  def call() do
    log("startx.call has been called!")
    Tl.Startx.RunOnce.call()

    Tl.Startx.Supervisor.start_link(name: Tl.Startx.Supervisor)

    receive do
      {:DOWN, _, _, _, _} ->
        IO.puts("Startx is down")
    end
  end

  def log(text) do
    Tl.File.append(Path.expand("~/.tl/2020-01.log"), text)
  end
end
