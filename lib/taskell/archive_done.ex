defmodule Tl.Taskell.ArchiveDone do
  @moduledoc """
  Documentation for Tl.
  """

  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def done_archive() do
    Application.get_env(:tl, :paths)
    |> Access.get(:done_archive)
    |> Path.expand()
  end

  def call() do
    columns =
      get_file_entry()
      |> Tl.Parser.parse()
      |> Enum.reverse()

    done =
      columns
      |> Enum.find(&(Map.get(&1, :value) == "## Done"))

    new_content =
      columns
      |> Enum.map(fn %{value: value, content: content} ->
        if value === "## Done" do
          %Tl.Heading{value: value, content: []}
        else
          %Tl.Heading{value: value, content: content}
        end
      end)
      |> Enum.reduce("", fn column, acc ->
        acc <> Tl.Heading.to_string(column)
      end)

    File.write!(board(), new_content)

    timestamp = Time.to_iso8601(Time.utc_now())

    header = gen_header()

    content = Tl.Heading.to_string(done)

    if content != "\n## Done" do
      Tl.File.prepend(
        done_archive(),
        header <> Tl.Heading.to_string(done)
      )
    end
  end

  def gen_header() do
    date_string =
      Timex.now()
      |> Timex.format!("%F", :strftime)

    time_string =
      Timex.now()
      |> Timex.shift(hours: -4)
      |> Timex.format!("%r EDT", :strftime)

    full = Timex.format!(Timex.now(), "{ISO:Extended}")

    """
    =====================================================
    date: #{date_string} time: #{time_string}
    #{full}
    =====================================================
    """
  end

  def get_file_entry() do
    File.read!(board())
  end
end