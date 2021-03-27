defmodule Tl.CLI do
  def cap_file() do
    Application.get_env(:tl, :paths)[:capture_file]
    |> Path.expand()
  end

  def main([]), do: main(["help"])

  def main(["rep"]) do
    IO.inspect(Node.self())
  end

  def main(["help"]) do
    IO.puts("""
    - new cap <name>
    - cap <quick content>
    - startx
    - filename
      - prepend <filenames>
        - date <filenames>
        - datetime <filenames>
    - file
      - prepend <filename> <content>
      - append <filename> <content>
    - jrnl
      - lock
      - unlock
      - new <name>
      - refresh
    - taskell
      - archive-done
    - rm <filenames>
    """)
  end

  def main(["taskell" | rest]) do
    Tl.Taskell.call(rest)
  end

  def main(["rm" | rest]) do
    Tl.Rm.call(rest)
  end

  def main(["new" | rest]) do
    Tl.New.call(rest)
  end

  def main(["startx" | rest]) do
    # :os.cmd('epmd -daemon')
    # Node.start(:startx)
    # System.get_env("BEAM_COOKIE") |> String.to_atom() |> Node.set_cookie()

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

  def main(["cap"]) do
    {output, _} = System.cmd("xclip", ["-o"])
    IO.inspect(output)

    Tl.File.append(cap_file(), "- " <> output)
  end

  def main(["cap" | args]) do
    content =
      args
      |> Enum.join(" ")
      |> IO.inspect()

    Tl.File.append(cap_file(), "- " <> content)
  end
end
