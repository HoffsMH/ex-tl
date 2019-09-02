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

    IO.puts new_content

    IO.puts "OUTPUTING DONE"
    IO.puts Tl.Heading.to_string(done)

    # Enum.reduce(columns, )
    # Enum.reduce
    # File.write(board, new_content)
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
