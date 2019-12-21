defmodule Tl.CLI do

  def main(["help"]) do
    IO.puts """
    - start-server
    - filename
      - prepend
        - date
        - datetime
    - file
      - prepend <content>
      - append <content>
    - jrnl
      - lock
      - unlock
      - new <name>
    """
  end

  def main(["start-server" | rest]) do
    IO.inspect(Enum.at(rest, 0))

    {:ok, board_monitor} =
      Tl.Watcher.start_link(
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

  def main(["filename" | rest]) do
    Tl.Filename.call(rest)
  end

  def main(["file" | rest]) do
    Tl.File.call(rest)
  end

  def main(["jrnl" | rest]) do
    Tl.Jrnl.call(rest)
  end
end
