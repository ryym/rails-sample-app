def create_user(name, email, &block)
  user = User.new(
    name: name,
    email: email,
    password: 'password',
    password_confirmation: 'password'
  )
  block.call user if block_given?
  user.save
end

create_user 'Example User', 'example@railstutorial.org' do |user|
  user.admin = true
end

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  create_user name, email
end
