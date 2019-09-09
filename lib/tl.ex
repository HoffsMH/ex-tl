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

  def dump_done() do
    columns = get_file_entry()
    |> Map.get(:content)
    |> Tl.Parser.parse()
    |> Enum.reverse()

    done = columns
    |> Enum.find(&(Map.get(&1, :value) == "## Done"))

    new_content = columns
    |> Enum.map(fn %{value: value, content: content} ->
      if (value === "## Done") do
        %Tl.Heading{ value: value, content: [] }
      else
        %Tl.Heading{ value: value, content: content }
      end
    end)
    |> Enum.reduce("", fn column, acc ->
      acc <> Tl.Heading.to_string(column)
    end)

    File.write!(Path.expand("~/personal/01-schedule/board/taskell.md"), new_content)

    timestamp = Time.to_iso8601(Time.utc_now())

    Tl.CLI.append(Path.expand("~/personal/00-capture/done-archive.md"), timestamp <> Tl.Heading.to_string(done))
  end

  def get_file_entry() do
    FaMap.gen_file_entry("~/personal/01-schedule/board/taskell.md")
  end

  def get_heading_content(heading, file_entry) do
    file_entry
    |> Map.get(:content)
    |> Tl.Parser.parse()
    |> Enum.find(&(Map.get(&1, :value) == "## #{heading}"))
    |> IO.inspect()
    |> Map.get(:content)
  end
end
