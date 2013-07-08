namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    first = User.create!(name:  "Example User",
                 email: "test@example.com",
                 password:  "testpass",
                 password_confirmation: "testpass")

    99.times do |n|
      first_name = Faker::Name.first
      last_name = Faker::Name.last
      email = "test-#{n+1}@example.com"
      password = "password"
      User.create!(first: first_name,
                   last: last_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
