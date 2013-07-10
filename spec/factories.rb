FactoryGirl.define do
  factory :user do
    first                 "Jane"
    sequence(:last)       { |n| "Doe #{n}" }
    sequence(:email)      { |n| "jdoe_#{n}@example.com" }
    password              "testPass"
    password_confirmation "testPass"
  end

  factory :group do
    name                  "Test Group"
    location              "Los Angeles, California, USA"
  end
end
