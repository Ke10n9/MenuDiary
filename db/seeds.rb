User.create!(name:  "Example User",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  password = "password"
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end
