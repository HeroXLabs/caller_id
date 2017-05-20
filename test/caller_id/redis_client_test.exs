defmodule CallerId.RedisClientTest do
  use ExUnit.Case

  alias CallerId.RedisClient
  alias CallerId.StubNextCallerIdClient

  test "lookup phone number" do
    {:ok, payload} = StubNextCallerIdClient.lookup("")
    phone_number   = "+16267314363"
    prefix         = "redis-client-test"

    RedisClient.set(prefix, phone_number, payload)

    {:ok, result} = RedisClient.get(prefix, phone_number)
    assert Map.get(result, "add_ons")

    RedisClient.del(prefix, phone_number)
  end
end
