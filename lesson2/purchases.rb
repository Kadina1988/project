basket = {}
cost = []
total = 0

loop do
  puts 'Введите название товара:'
  name = gets.chomp
  if name == 'stop'
    break
  end
  puts 'Цена за штуку:'
  price = gets.to_i
  puts 'Количество:'
  quantity = gets.to_i
  basket[name] = {price: price, quantity: quantity }
end
puts basket
basket.each do |name, price, quantity|
  item = basket[name][:price] * basket[name][:quantity]
  puts " Стоймость #{name} = #{item}"
  cost << item
end
cost.each {|i| total += i }
puts "Общая стоймость корзины #{total}"
