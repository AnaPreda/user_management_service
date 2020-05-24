use Mix.Config

config :user_management_service, UserManagementService.Repo,
       database: "users",
       username: "postgres",
       password: "1234",
       hostname: "localhost",
       show_sensitive_data_on_connection_error: true,
       pool_size: 10

config :user_management_service,
       UserManagementService.Endpoint,
       http: [
              port: 4000
       ],
       debug_errors: true,
       code_reloader: true,
       check_origin: false,
       watchers: []

config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime