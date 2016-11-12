defmodule CallerId.Client do
  @type phone_number :: String.t
  @type result       :: {:ok, any} | {:error, String.t}

  @callback lookup(any, phone_number) :: result
  @callback lookup(phone_number) :: result
end
