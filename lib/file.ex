defmodule Tl.File do
  def call(["append", filename, content]),
    do: append(filename, content)

  def call(["prepend", filename, content]),
    do: prepend(filename, content)

  def prepend(filename, new_content) do
    with full_path <- Path.expand(filename) do
      File.touch(full_path)
      {:ok, file} = File.open(full_path)
      {:ok, current_content} = File.read(full_path)

      full_path
      |> File.write(new_content <> current_content)

      File.close(file)
    end
  end

  def append(filename, content) do
    filename = Path.expand(filename)

    if !File.regular?(filename) do
      Path.dirname(filename)
      |> File.mkdir_p!()

      File.touch!(filename)
    end

    {:ok, file} = File.open(Path.expand(filename), [:append])

    IO.write(file, "\n" <> content)
    File.close(file)
  end

  def overwrite(filename, content) do
    with {:ok, file} <- File.open(Path.expand(filename), [:write]) do
      IO.binwrite(file, content)
      File.close(file)
    end
  end

  def read(filename) do
    with {:ok, file} <- File.open(Path.expand(filename), [:read]),
         content <- IO.binread(file, :all) do
      File.close(file)
      content
    end
  end

  defdelegate ls!(dir), to: File
  defdelegate rename(x, y), to: File
  defdelegate touch(x), to: File
  defdelegate chmod(x, y), to: File
  defdelegate mkdir_p!(x, y), to: File
end
