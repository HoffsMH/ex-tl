defmodule Tl.Jrnl do
  def cmd(),
    do: Application.get_env(:tl, :cmd_module, Tl.Cmd)

  def file(),
    do: Application.get_env(:tl, :file_module, File)

  def path(),
    do: Application.get_env(:tl, :path_module, Path)

  def paths_config(key),
    do: Application.get_env(:tl, :paths)[key]

  def user_config(key),
    do: Application.get_env(:tl, :user)[key]

  def jrnl_archive, do: paths_config(:jrnl_archive)

  def email, do: user_config(:gpg_email)

  def config do
    Application.get_env(:tl, Tl.Jrnl)
  end

  def call(["refresh"]) do
    filename =
      sorted_archived_gpg_list()
      |> Enum.at(0)

    file.cp!(filename, "#{file.cwd!()}/#{path.basename(filename)}")
  end

  def call(["lock"]) do
    IO.puts("current dir is #{file.cwd!()}")
    file.cd!(file.cwd!())
    tar_filename = jrnl_tar_filename()
    cmd.exec("tar", ["-cf", tar_filename | basename_entry_list() ++ ["--force-local"]])
    cmd.exec("gpg", ["--encrypt", "--recipient", email(), tar_filename])

    entry_list()
    |> Enum.each(&file.rm!/1)

    file.rm!(tar_filename)

    archive_gpg()
  end

  def basename_entry_list() do
    entry_list()
    |> Enum.map(&path.basename/1)
  end

  def jrnl_tar_filename() do
    "#{Tl.Time.iso()}-#{files_digest(entry_list())}.tar"
  end

  def call(["unlock"]) do
    IO.puts("current dir is #{file.cwd!()}")
    file.cd!(file.cwd!())
    archive_gpg()

    sorted_gpg_list()
    |> Enum.each(fn gpg_file ->
      cmd.exec("gpg", ["--decrypt", "--use-embedded-filename", gpg_file])
      file.rm!(gpg_file)

      tar_list()
      |> Enum.map(fn tar_file ->
        cmd.exec("tar", ["-xkvf", tar_file, "--force-local"])
        file.rm!(tar_file)
      end)
    end)
  end

  def call(["new", entry_name]) do
    cmd.exec("touch", [path.expand("./#{entry_name}.md")])
    Tl.Filename.call(["prepend", "datetime", path.expand("./#{entry_name}.md")])
  end

  def archive_gpg() do
    File.mkdir(complete_jrnl_archive())

    sorted_gpg_list
    |> Enum.each(fn filename ->
      filename
      |> file.cp!(path.expand(jrnl_archive() <> "/#{jrnl_name()}/#{path.basename(filename)}"))
    end)
  end

  def sorted_gpg_list() do
    "./*.gpg"
    |> path.expand()
    |> path.wildcard()
    |> Enum.sort()
    |> Enum.reverse()
  end

  def jrnl_name() do
    jrnl_name =
      file.cwd!()
      |> String.split("/")
      |> Enum.reverse()
      |> Enum.at(0)
  end

  def complete_jrnl_archive() do
    path.expand(jrnl_archive() <> "/#{jrnl_name()}")
  end

  def sorted_archived_gpg_list() do
    "#{complete_jrnl_archive()}/*.gpg"
    |> path.wildcard()
    |> Enum.sort()
    |> Enum.reverse()
  end

  def tar_list() do
    path.wildcard("./*.tar")
  end

  def entry_list() do
    path.wildcard("./*.{md,org}")
    |> Enum.map(&path.expand/1)
  end

  def files_digest([]), do: ""

  def files_digest(filenames) do
    # I want to use System.cmd here
    {content, 0} = System.cmd("cat", filenames)

    digest(content)
  end

  def digest(text) do
    :crypto.hash(:sha256, text)
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(-10, 10)
  end

  def digest_jrnl_content() do
    files_digest(entry_list())
  end
end
