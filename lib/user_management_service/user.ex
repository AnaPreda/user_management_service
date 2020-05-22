defmodule UserManagementService.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias UserManagementService.{User, Repo}
  @primary_key {:username, :string, []}
#  @derive {Phoenix.Param, key: :username}
  schema "users" do
    field :password, :string
    field :email_address, :string
    field :first_name, :string
    field :last_name, :string
    field :staff_status, :integer, default: 1

    timestamps
  end

  @fields ~w(username password email_address first_name last_name staff_status)a

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:username, :password, :email_address])
  end

  def create(params) do
    cs = changeset(%User{}, params)
#         |> validate_item_count(params)
#         |> put_assoc(:invoice_items, get_items(params))

#    if cs.valid? do
      Repo.insert(cs)
#    else
#      cs
#    end
  end
end