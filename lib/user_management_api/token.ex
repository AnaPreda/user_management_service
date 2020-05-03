defmodule UserManagementService.Models.Token do
  @db_name Application.get_env(:users, :redb_db)
  @db_table "tokens"
  use UserManagementService.Models.Base
  alias UserManagementService.DB.Manager
  # Poison Enconder Type
  @derive [Poison.Encoder]
  defstruct [
    :id,
    :type, #activation, reset
    :user,
    :used,
    :expires_at,
    :created_at,
    :updated_at
  ]
end
