defmodule UserManagementService.Repository do

#  def add_dog (dog) do
#    :ets.insert(:my_dogs, {"dog", dog})
#  end

  def get_users() do
    :ets.lookup(:my_users, "user")
    |> Enum.map (fn(x) -> elem(x,1) end)
  end

#  def get_dog_by_name(dog_name) do
#    :ets.lookup(:my_dogs, "dog")
#    |> Enum.filter(fn(x) -> elem(x,1).name == dog_name end)
#    |> Enum.map (fn(x) -> elem(x,1) end)
#  end
end
