FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    color { "MyString" }
    user_id { 1 }
  end
end
