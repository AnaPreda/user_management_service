defmodule UserManagementService.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :email_address
      remove :first_name
      remove :last_name
      remove :staff_status
    end
  end
end
