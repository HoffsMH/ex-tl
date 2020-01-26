defmodule Tl.CLI do
  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def main([]), do: main(["help"])

  def main(["help"]) do
    IO.puts("""
    - startx
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

  def main(["start" | rest]) do
    Tl.Start.call(rest)
  end

  def main(["startx" | rest]) do
    Tl.Startx.call(rest)
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
