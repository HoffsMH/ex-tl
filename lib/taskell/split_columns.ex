defmodule Tl.Taskell.SplitColumns do
  def file(), do: Application.get_env(:tl, :file_module, Tl.File)

  def board_path() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
  end

  def dir(), do: Application.get_env(:tl, :taskell_split_dir)

  def call(_args), do: call()

  def call() do
    parsed_board()
    |> Enum.map(fn %{value: value, content: content} ->
      column_path =
        value
        |> column_filename()

      new_content =
        content
        |> Enum.reverse()
        |> Enum.join("\n")

      file.overwrite(column_path, new_content)
      log("successfully wrote to #{column_path} : #{new_content}")
    end)
  end

  def log(text) do
    Tl.log("split_columns", text)
  end

  def board_content(), do: file.read(board_path())

  def parsed_board() do
    board_content()
    |> Tl.Parser.parse()
  end

  def column_filename(value) do
    name =
      value
      |> String.replace("## ", "")
      |> String.downcase()

    Path.expand(name <> ".md", dir)
  end
end
