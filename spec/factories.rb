FactoryGirl.define do
  factory :user do
    first                 "Jane"
    last                  "Doe"
    email                 "test@example.com"
    password              "testPass"
    password_confirmation "testPass"
  end
end
