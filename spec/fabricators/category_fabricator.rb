Fabricator(:category) do
  name { Faker::Lorem.word }
  ebay_id { Faker::Number.number(5) }
end