defmodule Tl do
  @moduledoc """
  Documentation for Tl.
  """
  @columns %{
    "Warm" => "~/personal/00-capture/warm.md",
    "Selected" => "~/personal/00-capture/selected.md",
    "Waiting on something" => "~/personal/00-capture/waiting-on.md",
    "Doing" => "~/personal/00-capture/doing.md",
    "Done" => "~/personal/00-capture/done.md"
  }

  def columns() do
    @columns
  end

  def get_done() do
    get_done(FaMap.gen_file_entry("~/personal/01-schedule/board/taskell.md"))
  end

  def get_done(file_entry) do
    get_heading_content("Done", file_entry)
  end

  def get_file_entry() do
    FaMap.gen_file_entry("~/personal/01-schedule/board/taskell.md")
  end

  def get_heading_content(heading, file_entry) do
    file_entry
    |> Map.get(:content)
    |> Tl.Parser.parse()
    |> Enum.find(&(Map.get(&1, :value) == "## #{heading}"))
    |> Map.get(:content)
  end
end
