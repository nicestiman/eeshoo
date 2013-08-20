FactoryGirl.define do
  factory :user, aliases: [:author] do
    first                 "Jane"
    sequence(:last)       { |n| "Doe #{n}" }
    sequence(:email)      { |n| "jdoe_#{n}@example.com" }
    password              "testPass"
    password_confirmation "testPass"
  end

  factory :group do
    name                  "Test Group"
    location              "US.CA"
    trait :populated
      ignore do
        user 5
      end
      after(:create) do |group, evaluator|
        FactoryGirl.create_list(:user, evaluator.user)
    end
  end
  
  factory :post do
    content               "lorim ipsom dolor sett jekre pepol vopelt telmp terompeal"
    species               "default"
    author
    group
  end

  factory :translation do
    locale                "en"
    key                   "sign_in"
    value                 "Sign in"
  end
end
