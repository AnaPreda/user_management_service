defmodule UserManagementService.Endpoint do
  require Logger
  use Plug.Router

#  alias UserManagementService.Models.User, as: User
  alias UserManagementService.User, as: User
  alias UserManagementService.Repo, as: Repo
  alias UserManagementService.Auth, as: Auth
  plug(:match)

  @skip_token_verification %{jwt_skip: true}

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug CORSPlug, origin: "*"


#  pipeline :api do
#    plug CORSPlug, origin: "*"
#    plug :accepts, ["json"]
#  end

#  scope "/api", UserManagementService do
#    pipe_through :api
#
##    resources "/", UserManagementService.Endpoint
##    options   "/signup", UserManagementService.Endpoint, :signup
##    options   "/articles/:id", ArticleController, :options
#
#    post "/signup", UserManagementService.Endpoint, :signup
#    post "/login", UserManagementService.Endpoint, :login
#  end


#  plug UserManagementService.AuthPlug
  plug(:dispatch)
#  , private: @skip_token_verification
    post "/signup"do
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
    end
  end

#  , private: @skip_token_verification
  post "/login" do
    {username, password} = {
      Map.get(conn.params, "username", nil),
      Map.get(conn.params, "password", nil)
    }
    user = Repo.get(User, username)
    case is_nil(user) do
          false ->
            case Bcrypt.verify_pass(password, user.password) do
              true ->
                {:ok, auth_service} = Auth.start_link
                case Auth.issue_token(auth_service, %{:id => username}) do
                  token ->
                    conn
                    |> put_resp_content_type("application/json")
                    |> send_resp(200, Poison.encode!(%{:token => token}))
                  :error ->
                    conn
                    |> put_resp_content_type("application/json")
                    |> send_resp(400, Poison.encode!(%{:message => "token already issued"}))
                end
              false ->
                conn
                |> put_resp_content_type("application/json")
                |> send_resp(200, Poison.encode!(%{"error" => "'user' not found"}))
            end
          true ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Poison.encode!(%{"error" => "'user' not found"}))
        end
    end
#  , private: @skip_token_verification
  post "/logout" do
    username = Map.get(conn.params, "username", nil)

    case Auth.revoke_token(conn.assigns.auth_service, %{:id => username}) do
      :ok ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{:message => "token was deleted"}))
      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Poison.encode!(%{:message => "token was not deleted"}))
    end
  end


  forward("/users", to: UserManagementService.Router)

  match _ do
    send_resp(conn, 404, "Page not found!")
  end

end
