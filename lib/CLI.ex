defmodule Tl.CLI do

  def main(["dump-done"]) do
    append("~/personal/00-capture/hourly.md", "It is" <> Time.to_iso8601(Time.utc_now()))
  end

  def append(filename, content) do

    filename = Path.expand(filename)

    File.touch(filename)
    old_content = File.read!(filename);
    File.write!(filename, old_content <> "\n" <> content)
  end

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

    # IO.inspect(Application.start())

    receive do
      {:DOWN, ^ref, _, _, _} ->
        IO.puts("Process #{inspect(my_monitor)} is down")
    end
  end

  def main(args) do
    IO.inspect(args)
  end
end
