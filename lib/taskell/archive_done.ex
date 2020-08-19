defmodule Tl.Taskell.ArchiveDone do
  @moduledoc """
  Documentation for Tl.
  """

  def file(), do: Application.get_env(:tl, :file_module, Tl.File)

  def board() do
    Application.get_env(:tl, :paths)
    |> Access.get(:taskell_board)
    |> Path.expand()
  end

  def done_archive_dir() do
    Application.get_env(:tl, :paths)
    |> Access.get(:done_archive_dir)
    |> Path.expand()
  end

  def call() do
    columns =
      get_columns()

    done =
      columns
      |> Enum.find(&(Map.get(&1, :value) == "## Done"))

    new_content =
      columns
      |> Enum.reduce("", &column_reducer/2)

    log("about to File.Write! content to board: #{new_content}")
    File.write!(board(), new_content)
    log("reading content of board now: #{File.read!(board())}")

    if should_archive?(done) do
      file.mkdir_p!(done_archive_dir)

      with filename <- Path.expand(Tl.Time.iso() <> ".md", done_archive_dir) do
        file.touch(filename)

        file.prepend(
          filename,
          gen_header() <> Tl.Heading.to_string_content_only(done)
        )
      end
    end
  end

  def column_reducer(%{value: "## Done", content: content}, acc),
    do: acc <> Tl.Heading.to_string(%{value: "## Done", content: []})

  def column_reducer(column, acc),
    do: acc <> Tl.Heading.to_string(column)

  def should_archive?(done) do
    Tl.Heading.any_content?(done)
  end

  def gen_header() do
    alias Tl.Time, as: T

    """
    =====================================================
    date: #{T.datestamp()} time: #{T.hours_minutes()}
    #{T.iso()}
    =====================================================
    """
  end

  def get_columns() do
    file.read(board())
    |> Tl.Parser.parse()
    |> Enum.reverse()
  end

  def log(text) do
    Tl.log("archive_done", text)
  end
end
