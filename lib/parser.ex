defmodule Tl.Parser do
  alias Tl.Heading

  @toplevelheading ~r{^\#\# (.*)$}

  def parse(""), do: []

  def parse(content) when is_binary(content) do
    parse(String.split(content, "\n"))
  end

  def parse(content) when is_list(content) do
    parse(content, [])
  end

  def parse([], headings), do: headings

  def parse([line | rest], headings) do
    parse(rest, mutate_headings(headings, line))
  end

  def mutate_headings(headings, line) do
    if determine_line_type(line) === :toplevelheading do
      [%Heading{value: line} | headings]
    else
      add_line_to_current_heading(headings, line)
    end
  end

  def add_line_to_current_heading([], line) do
    [
      %Heading{value: line}
    ]
  end

  def add_line_to_current_heading([current_heading | rest], line) do
    [
      Heading.add_line_to_content(current_heading, line)
      | rest
    ]
  end

  def determine_line_type(line) do
    if Regex.match?(@toplevelheading, line) do
      :toplevelheading
    else
      :subheading
    end
  end
end
