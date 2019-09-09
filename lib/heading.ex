defmodule Tl.Heading do
  defstruct value: "", content: []
  @heading_prefix "## "
  alias Tl.Heading

  def add_line_to_content(heading = %{content: content}, line) do
    %Heading{heading | content: [line | content]}
  end

  def ensure_formatting(""), do: ""

  def ensure_formatting(value) do
    "\n#{@heading_prefix}#{trim_value(value)}"
  end

  def to_string(%{value: value, content: content}) do
    "#{ensure_formatting(value)}#{concat_content(Enum.reverse(content))}"
  end

  def trim_value(%{value: value}) do
    trim_value(value)
  end

  def trim_value(value) do
    value
    |> String.replace_prefix(@heading_prefix, "")
    |> String.replace_suffix("\n", "")
  end

  def concat_content(content) do
    concat_content(content, "")
  end

  def concat_content([], output), do: output

  def concat_content([line | lines], output) do
    concat_content(lines, output <> "\n#{line}")
  end

  def value(%{value: value}) do
    value
  end
end
