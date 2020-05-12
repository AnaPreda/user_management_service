defmodule UserManagementService.Router do
  use Plug.Router
  use Timex
#  import UserManagementService.Repository
#  import UserManagementService.User
  alias UserManagementService.Models.User, as: User

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

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{"error" => "in get/"}))
  end

#  get "/" , private: %{view: UserView} do
#    params = Map.get(conn.params, "filter", %{})
#    username = Map.get(params, "q", "")
#
#    {:ok, users} =  User.match("username", username)
#
#    conn
#    |> put_resp_content_type("application/json")
#    |> send_resp(200, Poison.encode!(users))
#  end


#  get "/name" do
#    {name} = {
#      Map.get(conn.params, "name", nil)
#    }
#    conn
#    |> put_resp_content_type("application/json")
#    |> send_resp(200, Poison.encode!(Doggos.Repository.get_dog_by_name(name)))
#  end
#
  post "/" do
    {username, password, email_address, first_name, last_name} = {
      Map.get(conn.params, "username", nil),
      Map.get(conn.params, "password", nil),
      Map.get(conn.params, "email_address", nil),
      Map.get(conn.params, "first_name", nil),
      Map.get(conn.params, "last_name", nil)
    }

    cond do
      is_nil(username) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'username' field must be provided"})
      is_nil(password) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'password' field must be provided"})
      is_nil(email_address) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'email_address' field must be provided"})
      is_nil(first_name) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'first_name' field must be provided"})
      is_nil(last_name) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'last_name' field must be provided"})
      true ->
        case %User{
          username: username,
          password: password,
          email_address: email_address,
          first_name: first_name,
          last_name: last_name
        } |> User.save do
          {:ok, new_user}->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(201, Poison.encode!(%{:data => new_user}))
          :error ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(500, Poison.encode!(%{"error" => "An unexpected error happened"}))
          end
#        UserManagementService.Repository.add_user(%UserManagementService.Models.User{
#        username: username,
#        password: password,
#        email_address: email_address,
#        first_name: first_name,
#        last_name: last_name
#        })
#        conn
#        |> put_resp_content_type("application/json")
#        |> send_resp(201, Poison.encode!(%{:data => %UserManagementService.Models.User{
#         username: username,
#         password: password,
#         email_address: email_address,
#         first_name: first_name,
#         last_name: last_name
#        }}))
    end
  end
end
