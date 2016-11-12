defmodule CallerId.Utils do
  def map_keys_to_strings(map) do
    map
    |> Enum.reduce(%{}, fn ({k, v}, acc) -> Map.put(acc, to_string(k), v) end)
  end
end
