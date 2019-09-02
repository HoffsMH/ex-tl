defmodule Tl.CLI do
  def main(["start-server" | rest]) do
    IO.inspect(Enum.at(rest, 0))

    {:ok, my_monitor} =
      Watcher.start_link(
        dirs: [
          Path.expand("~/personal/01-schedule/board/taskell.md")
        ],
        name: :my_monitor
      )

    ref = Process.monitor(my_monitor)

    receive do
      {:DOWN, ^ref, _, _, _} ->
        IO.puts("Process #{inspect(my_monitor)} is down")
    end
  end

  def main(args) do
    IO.inspect(args)
  end
end
