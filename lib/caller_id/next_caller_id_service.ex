defmodule CallerId.NextCallerIdService do
  @use CallerId.Service
  @type phone_number :: String.t
  @type profile      :: Profile.t
  @type service      :: __MODULE__
  @type result       :: {:ok, profile} | {:error, String.t}

  defstruct client: CallerId.NextCallerIdClient

  alias ExTwilio.Lookup.PhoneNumber, as: Payload
  alias CallerId.Profile

  @spec lookup(service, phone_number) :: result
  def lookup(%__MODULE__{client: client}, phone_number) do
    with {:ok, %Payload{add_ons: payload}} <- client.lookup(phone_number),
                           nextcaller_data <- get_nextcaller_data(payload) do
      if success?(nextcaller_data) do
        with {:ok, record} <- get_record(nextcaller_data),
                   profile <- Profile.load(record),
         do: {:ok, profile}
      else
        {:error, get_status_message(nextcaller_data)}
      end
    end
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

  defp get_record(nextcaller_data) do
    case get_in(nextcaller_data, ["result", "records"]) do
      [record | _] -> {:ok, record}
      _ -> {:error, "missing record"}
    end
  end
end
