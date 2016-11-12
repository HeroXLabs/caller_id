defmodule CallerId.RedisClient do
  def get(prefix, key) do
    with {:ok, payload} <- cmd(~w(GET #{build_key(prefix, key)})) do
      case payload do
        nil -> {:error, "cannot find value"}
        payload -> Poison.decode(payload)
      end
    end
  end

  def set(prefix, key, payload) when is_map(payload) do
    with {:ok, encoded} = Poison.encode(payload),
     do: cmd(["SET", build_key(prefix, key), encoded])
  end

  def del(prefix, key) do
    cmd ["DEL", build_key(prefix, key)]
  end

  defp build_key(prefix, key), do: [prefix, key] |> Enum.join(":")
  defp cmd(cmd_params),        do: Redix.command(:redix, cmd_params)
end
