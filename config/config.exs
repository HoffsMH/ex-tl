use Mix.Config

config :tl, Tl, main_board: "~/personal/"

config :logger,
  level: :debug

config :tl, Tl.Scheduler,
  jobs: [
    {"0 */3 * * *", {Tl, :dump_done, []}},
  ]
