defmodule CallerId.Profile do
  defmodule Address do
    defstruct [:city, :zip_code, :state, :line_1]

    def load(%{
      "city" => city,
      "zip_code" => zip_code,
      "state" => state,
      "line1" => line_1}) do
      %__MODULE__{city: city, zip_code: zip_code, state: state, line_1: line_1}
    end
  end

  defmodule Social do
    defstruct [:type, :link]

    def load(%{"type" => type, "url" => link}) do
      %__MODULE__{type: type, link: link}
    end
  end

  defstruct first_name: nil,
            last_name:  nil,
            name:       nil,
            age:        nil,
            addresses:  [],
            socials:    []

  def load(%{
    "first_name"   => first_name,
    "last_name"    => last_name,
    "name"         => name,
    "age"          => age,
    "address"      => addresses,
    "social_links" => socials}) do

    %__MODULE__{
      first_name: first_name,
      last_name:  last_name,
      name:       name,
      age:        age
    }
    |> Map.merge(%{addresses: addresses |> Enum.map(&Address.load/1)})
    |> Map.merge(%{socials:   socials   |> Enum.map(&Social.load/1)})
  end
end
