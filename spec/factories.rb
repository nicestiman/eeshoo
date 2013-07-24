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
    location              "Los Angeles, California, USA"
  end
  
  factory :post do
    content               "lorim ipsom dolor sett jekre pepol vopelt telmp terompeal"
    title                 "Test Post"
    author
    group
  end
end
