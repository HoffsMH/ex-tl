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
      - split
      - archive-done
    - bw
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
    :os.cmd('epmd -daemon')
    Node.start(:startx)
    System.get_env("BEAM_COOKIE") |> String.to_atom() |> Node.set_cookie()

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

  def main(["pause_greenclip"]) do
    :os.cmd('epmd -daemon')
    Node.start(:cli)
    System.get_env("BEAM_COOKIE") |> String.to_atom() |> Node.set_cookie()
    startx = :"startx@localhost.localdomain"

    Node.spawn(startx, fn -> Tl.Startx.Supervisor.pause_greenclip() end)
  end

  def main(["start_greenclip"]) do
    :os.cmd('epmd -daemon')
    Node.start(:cli)
    System.get_env("BEAM_COOKIE") |> String.to_atom() |> Node.set_cookie()
    startx = :"startx@localhost.localdomain"

    Node.spawn(startx, fn -> Tl.Startx.Supervisor.start_greenclip() end)
  end

  def main(["bw" | args]) do
    # call bw list
    with {items_json, 0} <- System.cmd("bw", ["list", "items", "--search", "#{Enum.at(args, 0)}"]) do
      items =
        items_json
        |> Poison.decode!()
        |> Enum.map(&item_to_fzf/1)
        |> Enum.join("\n")

      fzf = Port.open({:spawn, "fzf --no-preview"}, [:binary])
      Port.command(fzf, items <> "\n")

      receive do
        {_, {:data, choice}} ->
          id =
            choice
            |> String.split("|")
            |> Enum.at(2)
            |> String.trim()

          pass =
            items_json
            |> Poison.decode!()
            |> Enum.find(&(get_id(&1) === id))
            |> get_password()

          IO.binwrite(:stdio, pass)

        _ ->
          IO.puts("error")
      end
    end
  end

  def item_to_fzf(%{"id" => id, "name" => name, "login" => %{"username" => username}}) do
    "#{name}|#{username}|#{id}"
  end

  def item_to_fzf(_), do: ""

  def get_password(%{"login" => %{"password" => password}}), do: password
  def get_id(%{"id" => id}), do: id
end
