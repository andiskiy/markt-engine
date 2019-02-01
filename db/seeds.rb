# Users created
User.create(first_name: 'Test', last_name: 'Admin', email: 'admin@example.com', password: '123456', role: 0)
User.create(first_name: 'Test', last_name: 'User', email: 'user@example.com', password: '123456')
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
  end
end
puts '-- Items created'
