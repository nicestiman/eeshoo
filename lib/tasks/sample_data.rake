namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    first = User.create!(first:  "Example",
                last: "User",
                email: "test@example.com",
                password:  "testpass",
                password_confirmation: "testpass")

    99.times do |n|
      first_name = Faker::Name.name
      last_name = Faker::Name.name
      email = "test-#{n+1}@example.com"
      password = "password"
      User.create!(first: first_name,
                   last: last_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    first.group.create!(name: "Sample Group", location: "US.CA")

    10.times do |n|
      new_member = User.find(n+2)
      Group.first.users << new_member
      Group.first.save!
    end
  end
end
