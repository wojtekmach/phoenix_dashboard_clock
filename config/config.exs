use Mix.Config

config :phoenix, :json_library, Jason

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix_live_dashboard,
  components: [
    {"/:node/clock", Phoenix.DashboardClock.ClockLive, :clock, "Clock"}
  ]
