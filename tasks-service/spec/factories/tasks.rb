FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    completed { false }
    priority { "MyString" }
    due_date { "2026-02-23" }
    user_id { 1 }
    project_id { 1 }
  end
end
