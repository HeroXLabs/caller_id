defmodule CallerId.NextCallerIdServiceTest do
  use ExUnit.Case

  alias CallerId.NextCallerIdService, as: S
  alias CallerId.Utils

  defmodule StubNextCallerIdClient do
    @use CallerId.Client

    def lookup("error_return"), do: {:error, "error return"}
    def lookup("invalid_return") do
      {:ok,
       %ExTwilio.Lookup.PhoneNumber{
         add_ons: %{"code" => nil, "message" => nil,
         "results" => %{"nextcaller_advanced_caller_id" => %{"code" => 61001,
           "message" => "Request timed out",
           "request_sid" => "XR92cfc83161cb78c5c38cd8bd460dd415", "result" => %{},
           "status" => "failed"}}, "status" => "successful"},
         carrier: nil,
         country_code: "US",
         national_format: "(626) 353-3507",
         phone_number: "+16263533507",
         url: "https://lookups.twilio.com/v1/PhoneNumbers/+16263533507"
       }
       |> Map.from_struct
       |> Utils.map_keys_to_strings
     }
    end
    def lookup(_) do
      {:ok,  %ExTwilio.Lookup.PhoneNumber{
        add_ons: %{
        "code" => nil,
        "message" => nil,
        "status" => "successful",
        "results" => %{
          "nextcaller_advanced_caller_id" => %{
            "code" => nil,
            "message" => nil,
            "request_sid" => "XRa4db418063f35f0696273ecc99b5bc65",
            "result" => %{
              "records" => [
                %{"address" => [
                  %{"city" => "Monterey Park",
                    "country" => "USA", "extended_zip" => "2520",
                    "line1" => "1155 W Newmark Ave", "line2" => "", "state" => "CA",
                    "zip_code" => "91754"}
                  ],
                  "age" => "32",
                  "email" => "he9lin@gmail.com",
                  "first_name" => "Lin",
                  "gender" => "Male",
                  "home_owner_status" => "Rent",
                  "household_income" => "75k-100k",
                  "id" => "0a0c857956777fa93314785ad4de4d",
                  "last_name" => "He",
                  "name" => "Lin He",
                  "phone" => [
                    %{"carrier" => "T-mobile", "line_type" => "Mobile",
                      "number" => "6267314363"}],
                  "social_links" => [
                    %{"type" => "facebook", "url" => "https://www.facebook.com/he9lin"}
                  ]
                }
              ]
            },
            "status" => "successful"
          }
        }
       },
       carrier: nil,
       country_code: "US",
       national_format: "(626) 731-4363",
       phone_number: "+16267314363",
       url: "https://lookups.twilio.com/v1/PhoneNumbers/+16267314363"}
       |> Map.from_struct
       |> Utils.map_keys_to_strings
     }
    end
  end

  setup do
    config = %S{client: StubNextCallerIdClient}
    {:ok, config: config}
  end

  test "returns a Profile struct", %{config: config} do
    {:ok, profile} = S.lookup(config, "+16262518951")
    assert profile.name == "Lin He"
    assert profile.first_name == "Lin"
    assert profile.last_name == "He"
  end

  test "returns error on client invalid return", %{config: config} do
    {:error, msg} = S.lookup(config, "invalid_return")
    assert msg == "Request timed out"
  end

  test "returns error on client error return", %{config: config} do
    {:error, msg} = S.lookup(config, "error_return")
    assert msg == "error return"
  end
end
