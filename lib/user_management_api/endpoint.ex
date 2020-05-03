defmodule UserManagementService.Endpoint do
  require Logger
  use Plug.Router

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

  post "/login", private: @skip_token_verification do
    {username, password} = {
      Map.get(conn.params, "username", nil),
      Map.get(conn.params, "password", nil)
    }

    flag = case username == "admin" and password == "admin"  do
      true ->
        {:ok, auth_service} = UserManagementService.Auth.start_link

        case UserManagementService.Auth.issue_token(auth_service, %{:id => username}) do
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
        |> send_resp(401, Poison.encode!(%{:message => "departamentul microsoft -> neatorizat!"}))

    end
  end

  forward("/users", to: UserManagementService.Router)

  match _ do
    send_resp(conn, 404, "Page not found!")
  end

end
