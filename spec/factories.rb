FactoryGirl.define do
  factory :user do
    first                 "Jane"
    sequence(:last)       { |n| "Doe #{n}" }
    sequence(:email)      { |n| "jdoe_tester#{n}example.com" }
    password              "testPass"
    password_confirmation "testPass"
  end

  factory :group do
    sequence(:name)       { |n| "Group #{n}"}
    location              "Los Angeles, California, USA"
  end
end
