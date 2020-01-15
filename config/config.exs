use Mix.Config

config :tl, Tl, main_board: "~/personal/"

config :logger,
  level: :debug

config :tl, Tl.Scheduler,
  jobs: [
    {"0 */3 * * *", {Tl.Taskell.ArchiveDone, :call, []}}
  ]

config :tl, :user,
  editor: "/usr/bin/subl3",
  gpg_email: "matthecker@pm.me"

config :tl, :paths,
  jrnl_dir: "~/personal/jrnl",
  jrnl_archive: "~/personal/personal-reference/jrnlarchive",
  taskell_board: "~/personal/01-schedule/board/taskell.md",
  done_archive: "~/personal/00-capture/done-archive.md"

config :tl, :taskell_columns, %{
  "Warm" => "~/personal/00-capture/warm.md",
  "Selected" => "~/personal/00-capture/selected.md",
  "Waiting on something" => "~/personal/00-capture/waiting-on.md",
  "Doing" => "~/personal/00-capture/doing.md"
}
