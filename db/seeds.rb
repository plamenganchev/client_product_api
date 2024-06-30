# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
puts 'Clearing existing data...'
Product.destroy_all
User.destroy_all
Brand.destroy_all
UserRole.destroy_all

# Seed user roles
puts 'Seeding user roles...'
admin_role = UserRole.create!(role: 'admin')
client_role = UserRole.create!(role: 'client')

puts 'User roles seeded successfully!'

# Seed users
puts 'Seeding users...'
admin_user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  user_role: admin_role
)

client_user = User.create!(
  email: 'client@example.com',
  password: 'password123',
  user_role: client_role
)

puts 'Users seeded successfully!'

# Seed brands
puts 'Seeding brands...'
10.times do
  Brand.create!(
    name: Faker::Company.name,
    country: Faker::Address.country_code,
    status: ['active', 'inactive'].sample
  )
end

puts 'Brands seeded successfully!'

# Seed products
puts 'Seeding products...'
brands = Brand.all

30.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price(range: 50.00..500.00),
    brand: brands.sample,
    status: ['active', 'inactive'].sample
  )
end

puts 'Products seeded successfully!'

puts 'Seed data successfully created!'