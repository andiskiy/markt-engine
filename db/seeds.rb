# Users created
User.create(first_name: 'Test', last_name: 'Super', email: 'super@example.com', password: '123456', role: 0)
User.create(first_name: 'Test', last_name: 'Admin', email: 'admin@example.com', password: '123456', role: 1)
1.upto(20) do |i|
  User.create(first_name: "Test-#{i}", last_name: "User-#{i}", email: "user_#{i}@example.com", password: '123456')
end
puts '-- Users created'

# Categories created
1.upto(20) do |i|
  Category.create(name: "Category-#{i}", description: 'This category from db/seeds')
end
puts '-- Categories created'

# Items created
Category.all.each_with_index do |category, index|
  1.upto(20) do |i|
    category.items.create(name: "Item-#{index + 1}-#{i}", description: 'This item from db/seeds', price: i * 10)
    puts "-- Item-#{index + 1}-#{i} created"
  end
end
puts '-- Items created'
