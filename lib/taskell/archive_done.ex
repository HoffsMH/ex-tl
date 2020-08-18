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

    log("about to File.Write! content to board: #{new_content}")
    File.write!(board(), new_content)
    log("reading content of board now: #{File.read!(board())}")

    if should_archive?(done) do
      file.mkdir_p!(done_archive_dir)
      # filename
      # file.touch(done_archive_dir <> "/" <> Tl.time.iso() <> ".md")
      # Tl.File.prepend(
      #   done_archive_dir(),
      #   gen_header() <> Tl.Heading.to_string_content_only(done)
      # )
    end
  end

  def should_archive?(done) do
    Tl.Heading.any_content?(done)
  end

  def gen_header() do
    alias Tl.Time, as: T

    """
    =====================================================
    date: #{T.datestamp} time: #{T.hours_minutes}
    #{T.iso}
    =====================================================
    """
  end

  def get_file_entry() do
    File.read!(board())
  end

  def log(text) do
    Tl.log("archive_done", text)
  end
end
