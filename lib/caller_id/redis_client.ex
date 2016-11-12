defmodule CalllerId.RedisClient do
  @use CalllerId.Client

  @type phone_number :: String.t
  @type result       :: {:ok, any} | {:error, String.t}

  @default_key "caller-id"

  @spec lookup(phone_number) :: result
  def lookup(phone_number) do
    with {:ok, payload} <- cmd(~w(GET #{key(phone_number)})) do
      case payload do
        nil -> {:error, "cannot find value"}
        payload -> Poison.decode(payload)
      end
    end
  end

  def set(phone_number, payload) when is_map(payload) do
    with {:ok, encoded} = Poison.encode(payload),
     do: cmd(["SET", key(phone_number), encoded])
  end

  def del(phone_number) do
    cmd ["DEL", key(phone_number)]
  end

  defp key(phone_number), do: [@default_key, phone_number] |> Enum.join(":")
  defp cmd(cmd_params),   do: Redix.command(:redix, cmd_params)
end
