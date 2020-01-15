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

    File.touch(filename)
    old_content = File.read!(filename)
    File.write!(filename, old_content <> "\n" <> content)
  end
end
