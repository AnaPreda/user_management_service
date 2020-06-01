use Mix.Config

config :joken, default_signer: "secret2"

config :bcrypt_elixir, log_rounds: 4

config :phoenix, :json_library, Jason

config :user_management_service,
       app_secret_key: "secret",
       jwt_validity: 3600,
       api_host: "localhost",
       api_version: "2",
       api_prefix: "http"


config :user_management_service, UserManagementService.Endpoint,
       url: [host: "localhost"]

config :cors_plug,
       send_preflight_response?: true

config :user_management_service, ecto_repos: [UserManagementService.Repo]

config :plug, :validate_header_keys_during_test, true

import_config "#{Mix.env()}.exs"