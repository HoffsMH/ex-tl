defmodule Tl.FontPatch do
  def file(), do: Application.get_env(:tl, :file_module, Tl.File)

  def unpatched_fonts do
    unpatched_dir
    |> file.ls!()
    |> Enum.map(&Path.expand(&1, unpatched_dir))
  end

  def font_patcher do
    base_dir <> "/font-patcher"
  end

  def intermediate_path do
    base_dir <> "/IBMmiddle"
  end

  def out_path do
    base_dir <> "/IBMout"
  end

  def base_dir do
    Path.expand("~/code/util/nerd-fonts")
  end

  def unpatched_dir do
    Path.expand("IBM", base_dir)
  end

  def call() do
    unpatched_fonts
    |> Enum.map(&patch_font/1)
  end

  def patch_font(font_path) do
    System.cmd(font_patcher, [font_path, "-c", "--careful", "--out", intermediate_path])

    with outfile <- List.first(File.ls!(intermediate_path)) do
      File.rename(
        Path.expand(outfile, intermediate_path),
        out_path <> "/" <> Path.basename(font_path)
      )
    else
      err ->
        require IEx
        IEx.pry()
    end
  end
end
