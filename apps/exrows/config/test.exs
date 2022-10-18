import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :exrows, Exrows.Repo,
  username: "u_exrows",
  password: "123@u_exrows@321",
  hostname: "localhost",
  database: "d_exrows_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exrows, ExrowsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ByPlpgELbzsOsm6pp51WLk7E2gNChRHccXiGczn4EqowHige7D1HaUxB3b29ltai",
  server: false

# In test we don't send emails.
config :exrows, Exrows.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
