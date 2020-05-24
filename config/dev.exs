use Mix.Config

config :user_management_service, UserManagementService.Repo,
       database: "users",
       username: "postgres",
       password: "1234",
       hostname: "localhost",
       show_sensitive_data_on_connection_error: true,
       pool_size: 10
