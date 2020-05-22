defmodule UserManagementService.Endpoint do
  require Logger
  use Plug.Router

#  alias UserManagementService.Models.User, as: User
  alias UserManagementService.User, as: User
  alias UserManagementService.Repo, as: Repo
  alias UserManagementService.Auth
  plug(:match)

  @skip_token_verification %{jwt_skip: true}

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug UserManagementService.AuthPlug
  plug(:dispatch)

  post "/signup", private: @skip_token_verification do
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

#        case User.match("username", username) do
        user = Repo.get(User, username)
        case  is_nil(user) do
             true ->
             hash_password = Bcrypt.hash_pwd_salt(password)
             case User.create(%{"username" => username, "password" => hash_password, "email_address" => email_address}) do
                 {:ok, new_user}->
                  conn
                 |> put_resp_content_type("application/json")
                 |> send_resp(201, Poison.encode!(%{:data => new_user}))
                 :error ->
                 conn
                 |> put_resp_content_type("application/json")
                 |> send_resp(500, Poison.encode!(%{"error" => "An unexpected error happened"}))
                 end
             false ->
               conn
               |> put_resp_content_type("application/json")
               |> send_resp(200, Poison.encode!(%{"error" => "User already registered"}))
             end
#          {:ok, users} ->
#            case users != [] do
#              true ->
#                conn
#                |> put_resp_content_type("application/json")
#                |> send_resp(200, Poison.encode!(%{"error" => "User already registered"}))
#              false ->
#                hash_password = Bcrypt.hash_pwd_salt(password)
#                case %User{
#                       id: nil,
#                       username: username,
#                       password: hash_password,
#                       email_address: email_address,
#                       first_name: first_name,
#                       last_name: last_name,
#                       staff_status: false
#                     } |> User.save do
#                case User.create(%{"username" => username, "password" => hash_password, "email_address" => email_address}) do
#                  {:ok, new_user}->
#                    conn
#                    |> put_resp_content_type("application/json")
#                    |> send_resp(201, Poison.encode!(%{:data => new_user}))
#                  :error ->
#                    conn
#                    |> put_resp_content_type("application/json")
#                    |> send_resp(500, Poison.encode!(%{"error" => "An unexpected error happened"}))
#                end
#            end
#
#          :error ->
#            conn
#            |> put_resp_content_type("application/json")
#            |> send_resp(500, Poison.encode!(%{"error" => "An unexpected error happened"}))
#        end


    end
  end

#  post "/login", private: @skip_token_verification do
#    {username, password} = {
#      Map.get(conn.params, "username", nil),
#      Map.get(conn.params, "password", nil)
#    }
#    case User.match("username", username) do
#      {:ok, users} ->
#       case users != [] do
#        true ->
#        user = List.first(users)
#        case Bcrypt.verify_pass(password, user.password) do
#          true ->
#          {:ok, auth_service} = UserManagementService.Auth.start_link
#          case UserManagementService.Auth.issue_token(auth_service, %{:id => username}) do
#          token ->
#            conn
#            |> put_resp_content_type("application/json")
#            |> send_resp(200, Poison.encode!(%{:token => token}))
#          :error ->
#            conn
#            |> put_resp_content_type("application/json")
#            |> send_resp(400, Poison.encode!(%{:message => "token already issued"}))
#            end
#
#          false ->
#            conn
#            |> put_resp_content_type("application/json")
#            |> send_resp(200, Poison.encode!(%{"error" => "'user' not found"}))
#            end
#        false ->
#           conn
#           |> put_resp_content_type("application/json")
#           |> send_resp(200, Poison.encode!(%{"error" => "'user' not found"}))
#      end
#
#      :error ->
#        conn
#        |> put_resp_content_type("application/json")
#        |> send_resp(200, Poison.encode!(%{"error" => "'user' not found"}))
#    end
#
#  end

  forward("/users", to: UserManagementService.Router)

  match _ do
    send_resp(conn, 404, "Page not found!")
  end

end
