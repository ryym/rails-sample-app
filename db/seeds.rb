# Users

def create_user(name, email, &block)
  user = User.new(
    name: name,
    email: email,
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
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


# Microposts

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
