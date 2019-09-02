use Mix.Config

config :logger,
  level: :debug


config :tl, Tl.Scheduler,
  jobs: [
    # Every minute
    # {"* * * * *", fn  ->
    #   # File.append("times.md", Timex.format!(Timex.now(), "%FT%T%:z", :strftime))
    #   # IO.puts "hi"
    # end},

    {"* * * * *",   {Tl, :logit, []} },
    # Runs every midnight:
    {"@daily",         {Backup, :backup, []}}
  ]
