defmodule CallerId.Service do
  @type phone_number :: String.t
  @type profile      :: Profile.t
  @type service      :: any
  @type result       :: {:ok, profile} | {:error, String.t}

  @callback lookup(service, phone_number) :: result
end
