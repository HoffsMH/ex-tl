defmodule Tl.CLI do
  def main(["dump-done"]) do
    append("~/personal/00-capture/hourly.md", "It is" <> Time.to_iso8601(Time.utc_now()))
  end

  def append(filename, content) do
    filename = Path.expand(filename)

    File.touch(filename)
    old_content = File.read!(filename)
    File.write!(filename, old_content <> "\n" <> content)
  end

  def main(["start-server" | rest]) do
    IO.inspect(Enum.at(rest, 0))

    {:ok, board_monitor} =
      Watcher.start_link(
        dirs: [
          Path.expand("~/personal/01-schedule/board/taskell.md")
        ],
        name: :board_monitor
      )

    ref = Process.monitor(board_monitor)

    receive do
      {:DOWN, ^ref, _, _, _} ->
        IO.puts("Process #{inspect(board_monitor)} is down")
    end
  end

  def main(args) do
    Timex.now()
    |> Timex.format!("%FT%T%:z", :strftime)
    |> IO.inspect()

    IO.inspect(args)
  end

  def prepend(path, new_content) do
    with full_path <- Path.expand(path) do
      File.touch(full_path)
      {:ok, file} = File.open(full_path)
      {:ok, current_content} = File.read(full_path)

      full_path
      |> File.write(new_content <> current_content)

      File.close(file)
    end
  end
end
