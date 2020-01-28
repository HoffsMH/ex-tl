defmodule Tl.Taskell.SplitColumns do
  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def columns(), do: Application.get_env(:tl, :taskell_columns)

  def call(_args), do: call()

  def call() do
    with {:ok, board_file} <- File.open(board(), [:read]),
         content <- IO.binread(board_file, :all) do
      File.close(board_file)
      log("successfully opened  and closed #{board()}")

      columns()
      |> Enum.map(fn {column_name, column_path} ->
        new_content =
          get_heading_content(column_name, content)
          |> Enum.reverse()
          |> Enum.join("\n")

        {:ok, file} = File.open(Path.expand(column_path), [:write])
        IO.binwrite(file, new_content)
        File.close(file)
        log("successfully wrote to #{column_path} : #{new_content}")
      end)
    end
  end

  def log(text) do
    Tl.log("split_columns", text)
  end

  def get_heading_content(heading, content) do
    content
    |> Tl.Parser.parse()
    |> Enum.find(&(Map.get(&1, :value) == "## #{heading}"))
    |> Map.get(:content)
  end
end
