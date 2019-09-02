defmodule Tl do
  @moduledoc """
  Documentation for Tl.
  """

  @doc """
      iex> Tl.get_done()
      "hii"
  """
  def get_done() do
    FaMap.gen_file_entry("~/personal/01-schedule/board/taskell.md")
    |> Map.get(:content)
    |> Tl.Parser.parse()
    |> Enum.find(&(Map.get(&1, :value) == "## Done"))
  end
end
