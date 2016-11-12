defmodule CallerId.NextCallerIdClient do
  @use CallerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, any} | {:error, String.t}

  @default_opts [AddOns: "nextcaller_advanced_caller_id"]

  @spec lookup(phone_number) :: result
  def lookup(phone_number) do
    ExTwilio.Lookup.retrieve(phone_number, @default_opts)
  end
end
