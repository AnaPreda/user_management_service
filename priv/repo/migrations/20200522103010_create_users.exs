defmodule UserManagementService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :username, :string, null: false, primary_key: true
      add :password, :string, null: false
      add :email_address, :string
      add :first_name, :string
      add :last_name, :string
      add :staff_status, :integer, default: 1

      timestamps
    end

  end
end
