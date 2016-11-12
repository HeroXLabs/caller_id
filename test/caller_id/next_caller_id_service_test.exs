defmodule CallerId.NextCallerIdServiceTest do
  use ExUnit.Case

  alias CallerId.NextCallerIdService, as: S
  alias CallerId.StubNextCallerIdClient

  @phone_number "+16262518951"
  @prefix       Application.get_env(:caller_id, :db_prefix)

  setup do
    config = %S{client: StubNextCallerIdClient}
    {:ok, config: config}
  end

  test "returns a Profile struct", %{config: config} do
    {:ok, profile} = S.lookup(config, @phone_number)

    assert %CallerId.Profile{
      age: "32",
      first_name: "Lin",
      last_name: "He",
      name: "Lin He",
      addresses: [
        %CallerId.Profile.Address{
          city: "Monterey Park",
          line_1: "1155 W Newmark Ave",
          state: "CA", zip_code: "91754"
        }
      ],
      socials: [
        %CallerId.Profile.Social{
          link: "https://www.facebook.com/he9lin",
          type: "facebook"
        }
      ]
    } == profile
  end

  test "returns error on client invalid return", %{config: config} do
    {:error, msg} = S.lookup(config, "invalid_return")
    assert msg == "Request timed out"
  end

  test "returns error on client error return", %{config: config} do
    {:error, msg} = S.lookup(config, "error_return")
    assert msg == "error return"
  end
end
