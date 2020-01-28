use Mix.Config

config :logger, level: :warn

config :tl, Tl.Scheduler,
  jobs: [
    {"0 */3 * * *", {Tl.Taskell.ArchiveDone, :call, []}},
    {"*/15 * * * *", {Tl.Jrnl.AutoLock, :call, []}}
  ]

config :tl, :user,
  editor: "/usr/bin/subl3",
  gpg_email: "matthecker@pm.me"

config :tl, :paths,
  jrnl_dir: "~/personal/jrnl",
  jrnl_archive: "~/personal/personal-reference/jrnlarchive",
  taskell_board: "~/personal/01-schedule/board/taskell.md",
  done_archive: "~/personal/00-capture/done-archive.md",
  capture_file: "~/personal/00-capture/capture.md"

# where we store our monthly log files
config :tl, :cmd, logfile_dir: "~/.tl/"

config :tl, :taskell_columns, %{
  "Warm" => "~/personal/00-capture/warm.md",
  "Selected" => "~/personal/00-capture/selected.md",
  "Waiting on something" => "~/personal/00-capture/waiting-on.md",
  "Today" => "~/personal/00-capture/today.md",
  "Doing" => "~/personal/00-capture/doing.md"
}

config :tl, :run_once, []

if File.regular?("./config/machine_specific.exs") do
  IO.puts("found machine specific config")
  import_config "machine_specific.exs"
end
