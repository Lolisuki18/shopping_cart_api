# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Xóa dữ liệu cũ
User.destroy_all
Product.destroy_all
Cart.destroy_all
CartItem.destroy_all

# Tạo sản phẩm mẫu
products = Product.create!([
  {
    name: "iPhone 15",
    description: "Latest iPhone model",
    price: 999.99,
    stock: 50
  },
  {
    name: "Samsung Galaxy S24",
    description: "Android flagship phone", 
    price: 899.99,
    stock: 30
  },
  {
    name: "MacBook Pro",
    description: "Apple laptop",
    price: 1999.99,
    stock: 20
  },
  {
    name: "AirPods Pro",
    description: "Wireless earbuds",
    price: 249.99,
    stock: 100
  }
])

# Tạo user test
user = User.create!(
  name: "Test User",
  email: "test@example.com", 
  password: "password123"
)

puts "✅ Created #{Product.count} products"
puts "✅ Created #{User.count} users"
puts "📧 User email: test@example.com"
puts "🔑 User password: password123"
