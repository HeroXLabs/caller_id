defmodule CallerId.CachableNextCallerIdClient do
  @behaviour CallerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, Map.t} | {:error, String.t}

  @spec lookup(phone_number) :: result

  defstruct client:    CallerId.NextCallerIdClient,
            db_client: CallerId.RedisClient,
            db_prefix: Application.get_env(:caller_id, :db_prefix)

  def lookup(%__MODULE__{
    client: client, db_client: store, db_prefix: db_prefix}, phone_number) do
    case store.get(db_prefix, phone_number) do
      {:error, _} ->
        with {:ok, payload} <- client.lookup(phone_number),
                          _ <- store.set(db_prefix, phone_number, payload),
                        do: {:ok, payload}
      ok -> ok
    end
  end

  def lookup(phone_number) do
    %__MODULE__{} |> lookup(phone_number)
  end
end
