defmodule CallerId.Client do
  @type phone_number :: String.t
  @type result       :: {:ok, any} | {:error, String.t}

  @callback lookup(phone_number) :: result
end
