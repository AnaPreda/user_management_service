defmodule UserManagementService.Endpoint do
  require Logger
  use Plug.Router

  alias UserManagementService.User, as: User
  alias UserManagementService.Repo, as: Repo
  alias UserManagementService.Auth, as: Auth
  alias UserManagementService.Service.Publisher, as: Publisher

  plug(:match)
  @skip_token_verification %{jwt_skip: true}
  @routing_keys Application.get_env(:user_management_service, :routing_keys)
  plug CORSPlug, origin: "*", credentials: true, methods: ["POST", "PUT", "DELETE", "GET", "PATCH", "OPTIONS"], headers: [ "Authorization", "Content-Type", "Accept", "Origin", "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken", "Keep-Alive", "X-Requested-With", "If-Modified-Since", "X-CSRF-Token"], expose: ['Link, X-RateLimit-Reset, X-RateLimit-Limit, X-RateLimit-Remaining, X-Request-Id']

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

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
        user = Repo.get(User, username)
        case  is_nil(user) do
             true ->
             hash_password = Bcrypt.hash_pwd_salt(password)
             case User.create(%{"username" => username, "password" => hash_password}) do
                 {:ok, new_user}->
                   Publisher.publish(%{"username" => username,"email_address" => email_address, "first_name" => first_name, "last_name" => last_name})
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


  post "/login", private: @skip_token_verification do
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
                |> send_resp(401, Poison.encode!(%{:unauthorized => "Invalid user or password"}))
            end
          true ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(401, Poison.encode!(%{:unauthorized => "'user' not found"}))
        end
    end

  post "/logout" do
    username = Map.get(conn.params, "username", nil)
    {:ok, service} = Auth.start_link
    case Auth.revoke_token(service, %{:id => username}) do
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

  post "/validate-token", private: @skip_token_verification do
    token = Map.get(conn.params, "token", nil)
    Logger.debug inspect(token)

    {:ok, service} = Auth.start_link
    case Auth.validate_token(service, token) do
      {:ok, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{:message => "token is valid"}))
      {:error, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Poison.encode!(%{:message => "token is invalid"}))
    end
  end

#  delete "/admin/delete_all" do
#    Repo.delete_all(User)
#    conn
#    |> put_resp_content_type("application/json")
#    |> send_resp(200, Poison.encode!(%{:message => "deleted"}))
#  end


  match _ do
    send_resp(conn, 404, "Page not found!")
  end

end
