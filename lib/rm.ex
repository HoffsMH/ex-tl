defmodule Tl.Rm do
  def file(), do: Application.get_env(:tl, :file_module, Tl.File)

  def trash_folder, do: Path.expand("~/.trash")

  def call([]), do: :ok

  def call([arg | rest]) do
    with filename <- Path.expand(arg),
         dirname <- Path.dirname(filename),
         basename <- Path.basename(filename),
         new_filename_base <- Path.expand(basename, trash_folder),
         new_filename <- new_filename_base <> "_" <> Tl.Jrnl.digest(filename),
         restore_script <- new_filename <> "_restore" do
      file().touch(restore_script)

      file().append(restore_script, """
      #!/bin/bash
      mv #{new_filename} #{filename} && rm #{restore_script}
      """)

      file().chmod(restore_script, 0o700)
      file().rename(filename, new_filename)
      call(rest)
    end
  end
end
