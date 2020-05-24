#defmodule UserManagementService.Repository do
#
##  def add_dog (dog) do
##    :ets.insert(:my_dogs, {"dog", dog})
##  end
#
#  def add_user (user) do
#    :ets.insert(:my_users, {"user", user})
#  end
#
#  def get_users() do
#    :ets.lookup(:my_users, "user")
#    |> Enum.map (fn(x) -> elem(x,1) end)
#  end
#
#  def get_user(username, password) do
#    :ets.lookup(:my_users, "user")
#    |> Enum.filter(fn(x) -> elem(x,1).username == username and elem(x,1).password == password end)
#    |>Enum.map (fn(x) -> elem(x,1) end)
#  end
#
#
##  def get_dog_by_name(dog_name) do
##    :ets.lookup(:my_dogs, "dog")
##    |> Enum.filter(fn(x) -> elem(x,1).name == dog_name end)
##    |> Enum.map (fn(x) -> elem(x,1) end)
##  end
#end
