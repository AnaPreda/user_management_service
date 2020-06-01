defmodule UserManagementService.Service.Publisher do
  use Timex
  use AMQP

  require Poison


  def publish(payload, options \\ []) do
    {:ok, connection} = AMQP.Connection.open("amqp://mljuxpih:gOWXSg5I0ibDw8Df1-zt24I7959uJYjb@roedeer.rmq.cloudamqp.com/mljuxpih")
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "profile")
    AMQP.Basic.publish(channel, "", "profile", Poison.encode!(payload))
    IO.puts " [x] Sent " <> Poison.encode!(payload)
    AMQP.Connection.close(connection)
  end
end