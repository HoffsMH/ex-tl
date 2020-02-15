defmodule Tl.Taskell.SplitColumns do
  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def dir(), do: Application.get_env(:tl, :taskell_split_dir)

  def columns(), do: Application.get_env(:tl, :taskell_columns)

  def call(_args), do: call()

  def call() do
    with content <- board_content() do
      parsed_board()
      |> Enum.map(fn %{value: value, content: content} ->
        column_path = value
        |> column_filename()
        |> Path.expand(dir)

        new_content = content
        |> Enum.reverse()
        |> Enum.join("\n")

        {:ok, file} = File.open(column_path, [:write])
        IO.binwrite(file, new_content)
        File.close(file)
        log("successfully wrote to #{column_path} : #{new_content}")
      end)
    end
  end

  def log(text) do
    Tl.log("split_columns", text)
  end

  def board_content(), do: board_content(board())
  def board_content(board_filename) do
    with {:ok, board_file} <- File.open(board(), [:read]),
         content <- IO.binread(board_file, :all) do
      File.close(board_file)
      log("successfully opened  and closed #{board()}")
      content
    end
  end

  def parsed_board() do
    board_content()
    |> Tl.Parser.parse()
  end

  def column_filename(value) do
    name = value
    |> String.replace("## ", "")
    |> String.downcase()
    name <> ".md"
  end
end
