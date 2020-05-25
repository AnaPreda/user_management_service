use Mix.Config

config :joken, default_signer: "secret2"

config :bcrypt_elixir, log_rounds: 4

config :phoenix, :json_library, Jason

config :user_management_service,
#       redb_host: "localhost",
#       redb_port: 28015,
#       redb_db: "users",
#       redb_tables: [
#         "users"
#       ],
       app_secret_key: "secret",
       jwt_validity: 3600,
       api_host: "localhost",
       api_version: "2",
       api_prefix: "http"

config :user_management_service, UserManagementService.Endpoint,
       url: [host: "localhost"]
#       secret_key_base: "ASZcFFBCOp0L1T+514xPNRh/23XvyM4UWp0PE4dvFzIHMhuwCG7ABLRnwgq41e8U",
#       render_errors: [view: UserManagementWeb.ErrorView, accepts: ~w(json)],
#       pubsub: [name: UserManagement.PubSub, adapter: Phoenix.PubSub.PG2],
#       live_view: [signing_salt: "oCfVawWa"]

#config :user_management_service, UserManagementService.Repo,
#       database: "users",
#       username: "postgres",
#       password: "1234",
#       hostname: "localhost"

#config :cors_plug,
#       origin: "*",
#       methods: ["GET", "POST"]
config :cors_plug,
       send_preflight_response?: true

config :user_management_service, ecto_repos: [UserManagementService.Repo]

config :plug, :validate_header_keys_during_test, true

import_config "#{Mix.env()}.exs"