defmodule Tl.Jrnl.AutoLock do

  def jrnl_dir() do
    Application.get_env(:tl, :paths)
    |> Access.get(:jrnl_dir)
    |> Path.expand()
  end

  def jrnl_files() do
    Path.wildcard(jrnl_dir() <> "/*.{md,gpg}")
  end

  def call() do

    log("auto locking has been called")
    minutes_ago = IO.inspect(jrnl_files)
    |> Enum.map(&File.stat!(&1, time: :posix))
    |> Enum.map(&Map.get(&1, :atime))
    |> Enum.max()
    |> Timex.from_unix()
    |> Timex.diff(Timex.now(), :minutes)

    log("auto lock has found a file that has been opened #{minutes_ago} minutes ago")
    if minutes_ago < -20 do
      log("deciding to lock")
      Tl.Jrnl.call(["lock"])
    end
  end

  def log(text) do
    Tl.log("jrnl autolock", text)
  end
end
