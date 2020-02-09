defmodule Tl.CLI do
  def cap_file() do
    Application.get_env(:tl, :paths)[:capture_file]
    |> Path.expand()
  end

  def main([]), do: main(["help"])

  def main(["help"]) do
    IO.puts("""
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
    - taskell
      - split
      - archive-done
    - bw
    """)
  end

  def main(["taskell" | rest]) do
    Tl.Taskell.call(rest)
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

  def main(["bw" | args ]) do
    # call bw list
    with {items_json, 0} <- System.cmd("bw", ["list", "items"]) do
      items = items_json
      |> Poison.decode!()
      |> Enum.map(&item_to_fzf/1)
      |> Enum.join("\n")

      fzf = Port.open({:spawn, "fzf --no-preview"}, [:binary])
      Port.command(fzf, items)

      receive do
        {^fzf, {:data, choice}} ->
          id = choice
          |> String.split("|")
          |> Enum.at(2)

          {pass, 0} = System.cmd("bw", ["get", "password", id])
          IO.binwrite(:stdio, pass)
      end
    end

  end

  def item_to_fzf(%{"id" => id, "name" => name, "login" => %{ "username" => username }}) do
    "#{name}|#{username}|#{id}"
  end

  def item_to_fzf(_), do: ""
end
