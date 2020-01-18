defmodule Tl.Taskell.SplitColumns do
  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def board_content() do
    File.read!(board())
  end

  def columns(), do: Application.get_env(:tl, :taskell_columns)


  def call(args), do: call()
  def call() do
    content = board_content()

    columns()
    |> Enum.map(fn {column_name, column_path} ->
      new_content =
        get_heading_content(column_name, content)
        |> Enum.reverse()
        |> Enum.join("\n")

      File.write!(Path.expand(column_path), new_content)
    end)
  end

  def get_heading_content(heading, content) do
    content
    |> Tl.Parser.parse()
    |> Enum.find(&(Map.get(&1, :value) == "## #{heading}"))
    |> IO.inspect()
    |> Map.get(:content)
  end
end
