use Mix.Config

config :joken, default_signer: "secret2"

config :bcrypt_elixir, log_rounds: 4

config :user_management_service,
       redb_host: "localhost",
       redb_port: 28015,
       redb_db: "users",
       redb_tables: [
         "users"
       ],
       app_secret_key: "secret",
       jwt_validity: 3600,
       api_host: "localhost",
       api_version: 2,
       api_prefix: "http"

