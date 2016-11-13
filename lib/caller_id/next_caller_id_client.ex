defmodule CallerId.NextCallerIdClient do
  @use CallerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, Map.t} | {:error, String.t}

  alias CallerId.Utils

  defstruct opts: [AddOns: "nextcaller_advanced_caller_id"]

  @spec lookup(any, phone_number) :: result
  def lookup(%__MODULE__{opts: opts}, phone_number) do
    with    {:ok, payload} <- ExTwilio.Lookup.retrieve(phone_number, opts),
                   payload <- normalize(payload),
   %{"add_ons" => add_ons} <- payload,
           nextcaller_data <- get_nextcaller_data(add_ons) do
      if success?(nextcaller_data) do
        {:ok, payload}
      else
        {:error, get_status_message(nextcaller_data)}
      end
    end
  end

  def lookup(phone_number) do
    %__MODULE__{} |> lookup(phone_number)
  end

  defp normalize(payload) do
    payload |> Map.from_struct |> Utils.map_keys_to_strings
  end

  defp get_nextcaller_data(payload) do
    get_in(payload, ["results", "nextcaller_advanced_caller_id"])
  end

  defp success?(nextcaller_data) do
    nextcaller_data |> Dict.get("status") == "successful"
  end

  defp get_status_message(nextcaller_data) do
    nextcaller_data |> Dict.get("message")
  end
end
