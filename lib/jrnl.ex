defmodule Tl.Jrnl do
  @jrnl_dir "~/personal/jrnl"
  @editor "/usr/bin/subl3"

  def call(["lock"]) do
    File.cd!(full_jrnl_path())
    tar_filename = jrnl_tar_filename
    System.cmd("tar", ["-cf", tar_filename | entry_list() |> Enum.map(&Path.basename/1)])
    System.cmd("gpg", ["--encrypt", "--recipient", "matthecker@pm.me", tar_filename])

    entry_list()
    |> Enum.each(&File.rm!/1)
    File.rm!(tar_filename)

    archive_gpg()
  end

  def jrnl_tar_filename() do
    "#{Tl.Time.datestamp}-#{files_digest(entry_list())}.tar"
  end

  def call(["unlock"]) do
    File.cd!(full_jrnl_path())
    archive_gpg()

    gpg_list()
    |> Enum.each(fn filename ->
      System.cmd("gpg", ["--decrypt", "--use-embedded-filename", filename])
      File.rm!(filename)
    end)

    tar_list()
    |> Enum.map(fn filename ->
      System.cmd("tar", ["-xf", filename])
      File.rm!(filename)
    end)
  end

  def call(["new", entry_name]) do
    System.cmd("touch", [full_jrnl_path() <> "/#{entry_name}.md"])
    Tl.Filename.call(["prepend", "datetime", full_jrnl_path() <> "/#{entry_name}.md"])
    System.cmd(@editor, [full_jrnl_path()])
  end

  def archive_gpg() do
    gpg_list
    |> Enum.each(fn filename ->
      File.cp!(filename, Path.expand("~/personal/personal-reference/jrnlarchive/#{Path.basename(filename)}"))
    end)
  end

  def gpg_list() do
    Path.wildcard(full_jrnl_path() <> "/*.gpg")
  end

  def tar_list() do
    Path.wildcard(full_jrnl_path() <> "/*.tar")
  end

  def entry_list() do
    Path.wildcard(full_jrnl_path() <> "/*.{md,org}")
  end

  def full_jrnl_path() do
    Path.expand(@jrnl_dir)
  end

  def files_digest([]), do: ""
  def files_digest(filenames) do
    {content, 0} = System.cmd("cat", filenames)

    :crypto.hash(:sha256, content)
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(-10, 10)
  end

  def digest_jrnl_content () do
    files_digest(entry_list)
  end
end
