defmodule CallerId.NextCallerIdClient do
  @use CallerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, Map.t} | {:error, String.t}

  @default_opts [AddOns: "nextcaller_advanced_caller_id"]

  alias CallerId.Utils

  @spec lookup(phone_number) :: result
  def lookup(phone_number) do
    ExTwilio.Lookup.retrieve(phone_number, @default_opts)
    |> Map.from_struct
    |> Utils.map_keys_to_strings
  end
end
