defmodule Tl.Filename do
  def call(["prepend", "date" | filenames]) do
    {:ok, prefix} =
      Timex.now()
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

  def call(["prepend", "datetime" | filenames]) do
    {:ok, prefix} =
      Timex.now()
      |> Timex.Timezone.convert(Timex.Timezone.local())
      |> Timex.format("%Y-%m-%dT%H:%M:%S.%z-", :strftime)

    Enum.each(filenames, fn filename ->
      full_filename = Path.expand(filename)
      basename = Path.basename(full_filename)
      dirname = Path.dirname(full_filename)

      newfilename = Path.expand(dirname <> "/" <> prefix <> basename)
      IO.inspect(Path.expand(filename))
      IO.inspect(newfilename)

      File.rename(filename, newfilename)
    end)
  end
end
