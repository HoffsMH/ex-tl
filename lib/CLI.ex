defmodule Tl.CLI do
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

  def main(["file", "prepend", "date" | filenames]) do
    {:ok, prefix} = Timex.now()
    |> Timex.format("%F-", :strftime)

    Enum.each(filenames, fn filename ->
      full_filename = Path.expand(filename)
      basename = Path.basename(full_filename)
      dirname = Path.dirname(full_filename)

      newfilename = Path.expand(dirname <> "/" <> prefix <> basename)
      IO.inspect(Path.expand(filename))
      IO.inspect(newfilename)

      File.rename(Path.expand(filename), newfilename)
    end)
  end

  def main(["file", "prepend", "datetime" | filenames]) do
    {:ok, prefix} = Timex.now()
    |> Timex.Timezone.convert(Timex.Timezone.local())
    |> Timex.format("%Y-%m-%dT%H:%M:%S.%z-", :strftime)

    Enum.each(filenames, fn filename ->
      full_filename = Path.expand(filename)
      basename = Path.basename(full_filename)
      dirname = Path.dirname(full_filename)

      newfilename = Path.expand(dirname <> "/" <> prefix <> basename)
      IO.inspect(Path.expand(filename))
      IO.inspect(newfilename)

      File.rename(Path.expand(filename), newfilename)
    end)
  end

  def main(["file", "create", "datetime" | filenames]) do
    {:ok, prefix} = Timex.now()
    |> Timex.Timezone.convert(Timex.Timezone.local())
    |> Timex.format("%Y-%m-%dT%H:%M:%S.%z-", :strftime)

    Enum.each(filenames, fn filename ->
      full_filename = Path.expand(filename)
      basename = Path.basename(full_filename)
      dirname = Path.dirname(full_filename)

      newfilename = Path.expand(dirname <> "/" <> prefix <> basename)
      IO.inspect(Path.expand(filename))
      IO.inspect(newfilename)

      File.touch(newfilename)
    end)
  end

  def main(["jrnl" | filenames]) do
    jrnl_path = Path.expand("~/personal/jrnl/")
    System.cmd("/usr/bin/subl3", [jrnl_path])

    Enum.each(filenames, fn filename ->
      full_filename = Path.expand(filename)
      basename = Path.basename(full_filename)
      dirname = Path.dirname(full_filename)

      newfilename = Path.expand(dirname <> "/" <> prefix <> basename)
      IO.inspect(Path.expand(filename))
      IO.inspect(newfilename)

      File.touch(newfilename)
    end)
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
