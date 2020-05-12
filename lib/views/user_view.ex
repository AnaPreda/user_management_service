defmodule UserManagementService.Views.UserView do
  use JSONAPI.View

  def fields, do: [:id, :username, :password, :email_address, :first_name, :last_name, :staff_status, :updated_at, :created_at]
  def type, do: "user"
  def relationships, do: []
end
