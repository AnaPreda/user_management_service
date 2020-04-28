defmodule UserManagementService.Router do
  use Plug.Router

  import UserManagementService.Repository
  import UserManagementService.User

  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(UserManagementService.Repository.get_users()))
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
