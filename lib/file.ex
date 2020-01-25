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

    {:ok, file} = File.open(Path.expand(filename), [:append])

    IO.write(file, "\n" <> content)
    File.close(file)
  end
end
