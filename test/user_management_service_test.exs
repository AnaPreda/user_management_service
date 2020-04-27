defmodule UserManagementServiceTest do
  use ExUnit.Case
  doctest UserManagementService

  test "greets the world" do
    assert UserManagementService.hello() == :world
  end
end
