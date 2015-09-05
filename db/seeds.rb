def create_user(name, email)
  User.create!(
    name: name,
    email: email,
    password: 'password',
    password_confirmation: 'password'
  )
end

create_user 'Example User', 'example@railstutorial.org'

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  create_user name, email
end
