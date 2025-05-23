import Config

# Do not include metadata nor timestamps in development logs
config :logger, :default_formatter,
  format: "[$level] $message\n",
  metadata: []

# Logger config
config :logger, :default_handler, level: :debug
