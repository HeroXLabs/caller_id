defmodule CallerId.CachableNextCallerIdClientTest do
  use ExUnit.Case

  alias CallerId.CachableNextCallerIdClient, as: C
  alias CallerId.StubNextCallerIdClient
  alias CallerId.RedisClient

  @phone_number "+16262518951"
  @prefix       Application.get_env(:caller_id, :db_prefix)

  defmodule DumbNextCallerIdClient do
    @behaviour CallerId.Client

    def lookup(_, _), do: {:error, "im dumb"}
    def lookup(_), do: {:error, "im dumb"}
  end

  setup do
    config = %C{client: DumbNextCallerIdClient}

    on_exit fn ->
      RedisClient.del(@prefix, @phone_number)
    end

    {:ok, config: config}
  end

  test "hits cache first", %{config: config} do
    {:ok, data} = StubNextCallerIdClient.lookup("")
    RedisClient.set(@prefix, @phone_number, data)

    {:ok, result} = C.lookup(config, @phone_number)
    assert result == data
  end

  test "caches in a redis db", %{config: _} do
    config = %C{db_prefix: @prefix, client: StubNextCallerIdClient}
    {:ok, _} = C.lookup(config, @phone_number)
    {:ok, result} = RedisClient.get(@prefix, @phone_number)
    assert Map.get(result, "add_ons")
  end
end
