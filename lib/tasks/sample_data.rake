namespace :db do
	desc "Fill database with sample Data"
	task populate: :environment do
		creating_users
	end
end

def creating_users
	User.create!(
			name: "admin",
			email: "admin@localhost.com",
			password: "123456",
			password_confirmation: "123456",
			admin: true
					)
	49.times do |n|
		name = Faker::Name.name
		email = "user-example-#{n+1}@localhost.com"
		password = "123456"
		User.create(
			name: name,
			email: email,
			password: password,
			password_confirmation: password
					)
	end
end