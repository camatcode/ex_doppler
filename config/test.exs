import Config

config :ex_doppler,
  token: System.get_env("DOPPLER_TOKEN") || raise("No DOPPLER_TOKEN set")
