defmodule Tl.Log do
  def log_dir(),
    do: Application.get_env(:tl, :cmd)[:logfile_dir]

  def current_log_file() do
    Path.expand(Tl.Time.monthstamp() <> ".log", Path.expand(log_dir))
  end

  def log(text) do
    current_log_file
    |> Tl.File.append(log_prefix() <> " " <> text)
  end

  def log(context, text) do
    current_log_file
    |>Tl.File.append(log_prefix(context) <> " " <> text)
  end

  def log_prefix(context) do
    log_prefix <> " [#{context}] "
  end

  def log_prefix do
    "[#{Tl.Time.iso()}]"
  end
end
