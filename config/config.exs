use Mix.Config

config :logger, level: :error

config :tl, Tl.Scheduler,
  jobs: [
    {"0 */3 * * *", {Tl.Taskell.ArchiveDone, :call, []}},
  ]

config :tl, :user,
  editor: "/usr/bin/subl3",
  gpg_email: "matthecker@pm.me"

config :tl, :paths,
  jrnl_dir: "~/personal/jrnl",
  jrnl_archive: "~/personal/personal-reference/jrnlarchive",
  taskell_board: "~/personal/00-capture/board/taskell.md",
  done_archive_dir: "~/personal/00-capture/done-archive/",
  capture_file: "~/personal/00-capture/capture.md",
  capture_dir: "~/personal/00-capture"

# where we store our monthly log files
config :tl, :cmd, logfile_dir: "~/.tl/"
config :logger, level: :error

if File.regular?("./config/machine_specific.exs") do
  IO.puts("found machine specific config")
  import_config "machine_specific.exs"
end
