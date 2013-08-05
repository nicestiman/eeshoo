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
    trait :populated do
      ignore do
        user 5
      end
      
      after(:create) do |group, evaluator|
        FactoryGirl.create_list(:user, evaluator.user)
      end
    end
  end
  
  factory :post do
    content               "lorim ipsom dolor sett jekre pepol vopelt telmp terompeal"
    title                 "Test Post"
    author
    group
  end

  factory :permission, class: RolePermission do
    sequence(:key)  {|n| "privlage#{n}"}
    sequence(:name)  {|n| "human readable name for a permission #{n}" }
  end
  
  factory :role do 
    sequence(:name)   { |n|  "role#{n}"}
    
    trait :filled do
      ignore do
        permission 5
      end
      
      after(:create) do |group, evaluator|
        FactoryGirl.create_list(:permission, evaluator.permission)
      end
    end
  end
end
