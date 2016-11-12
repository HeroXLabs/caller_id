defmodule CalllerId.RedisClientTest do
  use ExUnit.Case

  alias CalllerId.RedisClient
  alias ExTwilio.Lookup.PhoneNumber, as: Payload

  test "lookup phone number" do
    twilio_payload = %Payload{
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

     phone_number = "+16267314363"
     RedisClient.set(phone_number, twilio_payload)

     {:ok, result} = RedisClient.lookup(phone_number)
     assert Dict.get(result, "add_ons")

     RedisClient.del(phone_number)
  end
end
