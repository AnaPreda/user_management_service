defmodule UserManagementService.Router do
  use Plug.Router
  use Timex
#  import UserManagementService.Repository
#  import UserManagementService.User
  alias UserManagementService.Models.User

  @skip_token_verification %{jwt_skip: true}
  @skip_token_verification_view %{view: UserView, jwt_skip: true}
  @auth_url Application.get_env(:user_management_service, :auth_url)
  @api_port Application.get_env(:user_management_service, :port)
  @db_table Application.get_env(:user_management_service, :redb_db)
  @db_name Application.get_env(:user_management_service, :redb_db)

  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug UserManagementService.AuthPlug
  plug(:dispatch)

#  get "/" do
#    conn
#    |> put_resp_content_type("application/json")
#    |> send_resp(200, Poison.encode!(UserManagementService.Repository.get_users()))
#  end

  get "/" , private: %{view: UserView} do
    params = Map.get(conn.params, "filter", %{})
    username = Map.get(params, "q", "")

    {:ok, users} =  User.match("username", username)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(users))
  end


#  get "/name" do
#    {name} = {
#      Map.get(conn.params, "name", nil)
#    }
#    conn
#    |> put_resp_content_type("application/json")
#    |> send_resp(200, Poison.encode!(Doggos.Repository.get_dog_by_name(name)))
#  end
#
#  post "/" do
#    {name, age,id} = {
#      Map.get(conn.params, "name", nil),
#      Map.get(conn.params, "age", nil),
#      Map.get(conn.params, "id", nil)
#    }
#
#    cond do
#      is_nil(name) ->
#        conn
#        |> put_status(400)
#        |> assign(:jsonapi, %{"error" => "'name' field must be provided"})
#      is_nil(age) ->
#        conn
#        |> put_status(400)
#        |> assign(:jsonapi, %{"error" => "'age' field must be provided"})
#      is_nil(id) ->
#        conn
#        |> put_status(400)
#        |> assign(:jsonapi, %{"error" => "'id' field must be provided"})
#      true ->
#        Doggos.Repository.add_dog(%Doggos.Dog{
#          name: name,
#          age: age,
#          id: id,
#        })
#        conn
#        |> put_resp_content_type("application/json")
#        |> send_resp(201, Poison.encode!(%{:data => %Doggos.Dog{
#          name: name,
#          age: age,
#          id: id
#        }}))
#    end
#  end
end
