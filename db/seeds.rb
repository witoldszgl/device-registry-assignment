# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  puts "Clearing existing data..."
  Device.update_all(user_id: nil)
  DeviceAssignment.destroy_all
  Device.destroy_all
  User.destroy_all
  ApiKey.destroy_all
end


puts "Creating users..."
user1 = User.create!(email: 'admin@company.com', password: 'password123')
user2 = User.create!(email: 'manager@company.com', password: 'password123') 
user3 = User.create!(email: 'employee@company.com', password: 'password123')

puts "Users created:"
User.all.each { |u| puts "  ID: #{u.id}, Email: #{u.email}" }

puts "\nSeed data created successfully!"
puts "Users: #{User.count}"
puts "Ready for testing!"