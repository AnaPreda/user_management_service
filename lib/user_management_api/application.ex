defmodule UserManagementService.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    :ets.new(:my_users, [:bag, :public, :named_table])

    Supervisor.start_link(children(), opts())
  end
  defp children do
    [
      {Plug.Adapters.Cowboy2, scheme: :http,
        plug: UserManagementService.Endpoint, options: [port: 4000]},

      UserManagementService.Repo,
#      worker(UserManagementService.DB.Manager, [[
#        name: UserManagementService.DB.Manager,
#        host: Application.get_env(:user_management_service, :redb_host),
#        port: Application.get_env(:user_management_service, :redb_port)
#      ]]),
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: UserManagementService.Supervisor
    ]
  end

end