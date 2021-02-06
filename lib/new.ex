defmodule Tl.New do
  def main_capture_dir() do
    Application.get_env(:tl, :paths)
    |> Access.get(:capture_dir)
    |> Path.expand()
  end

  def call(["cap", cap_name]) do
    Tl.File.mkdir_p!(cap_dir(cap_name))

    with filename <- cap_file_name(cap_name) do
      {output, _} = System.cmd("xclip", ["-o"])

      Tl.File.touch(filename)
      Tl.File.append(filename, output)
      System.cmd("subl3", [filename])
    end
  end

  def cap_dir(cap_name) do
    main_capture_dir() <> "/cap-#{cap_name}/"
  end

  def cap_file_name(cap_name) do
    cap_dir(cap_name) <> "capture.md"
  end
end
