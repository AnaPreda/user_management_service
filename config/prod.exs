use Mix.Config

config :subs, UserManagementService.Repo,
       adapter: Ecto.Adapters.Postgres,
       url: System.get_env("DATABASE_URL"),
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2"),
       ssl: false

config :subs_web, SubsWeb.Endpoint,
       load_from_system_env: true,
       url: [host: {:system, "HOST"}, port: {:system, "PORT"}],
       server: true,
       version: Application.spec(:subs_web, :vsn),
       secret_key_base: System.get_env("SECRET_KEY_BASE"),
       session_cookie_name: System.get_env("SESSION_COOKIE_NAME"),
       session_cookie_signing_salt: System.get_env("SESSION_COOKIE_SIGNING_SALT"),
       session_cookie_encryption_salt: System.get_env("SESSION_COOKIE_ENCRYPTION_SALT")
