defmodule CallerId.NextCallerIdClient do
  @use CallerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, Map.t} | {:error, String.t}

  alias CallerId.Utils

  defstruct opts: [AddOns: "nextcaller_advanced_caller_id"]

  @spec lookup(any, phone_number) :: result
  def lookup(%__MODULE__{opts: opts}, phone_number) do
    ExTwilio.Lookup.retrieve(phone_number, opts)
    |> Map.from_struct
    |> Utils.map_keys_to_strings
  end

  def lookup(phone_number) do
    %__MODULE__{} |> lookup(phone_number)
  end
end
