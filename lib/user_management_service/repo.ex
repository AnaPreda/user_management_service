defmodule UserManagementService.Repo do
  use Ecto.Repo,
    otp_app: :user_management_service,
    adapter: Ecto.Adapters.Postgres
end
