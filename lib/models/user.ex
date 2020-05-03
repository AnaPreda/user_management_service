defmodule UserManagementService.Models.User do
  @db_name Application.get_env(:users, :redb_db)
  @db_table "users"

  use UserManagementService.Models.Base

  defstruct [
    :username,
    :email_address,
    :first_name,
    :last_name,
    :staff_status
  ]
end
