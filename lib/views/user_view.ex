defmodule UserManagementService.Views.UserView do
  use JSONAPI.View

  def fields, do: [:username, :email_address, :first_name, :last_name, :staff_status]
  def type, do: "user"
  def relationships, do: []
end
