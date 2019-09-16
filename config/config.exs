use Mix.Config

config :tl, Tl, main_board: "~/personal/"

config :logger,
  level: :debug

config :tl, Tl.Scheduler,
  jobs: [
    # Every minute
    {"* * * * *",      {Tl, :say_hi, []}},
    # Every 15 minutes
    {"*/15 * * * *",  {Tl, :say_hi, []}},
    # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # Runs every midnight:
    # {"@daily",         {Backup, :backup, []}}
  ]
