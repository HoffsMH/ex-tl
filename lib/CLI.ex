defmodule Tl.CLI do
  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def main([]), do: main(["help"])
  def main(["help"]) do
    IO.puts("""
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
    - taskell
      - split
    """)
  end

  def main(["taskell" | rest]) do
    Tl.Taskell.call(rest)
  end

  def main(["start-server" | rest]) do
    {:ok, board_monitor} =
      Tl.Watcher.start_link(
        dirs: [ board() ],
        name: :board_monitor
      )

    ref = Process.monitor(board_monitor)

    Tl.Cmd.perform_cmds([
      {"xset", ["r", "rate", "200", "30"]}
    ])

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
