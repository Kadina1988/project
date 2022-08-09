puts 'Как вас зовут'
name = gets.chomp
puts 'Какой у вас рост'
height = gets.to_i
ideal_weith = (height - 110) * 1.15
if ideal_weith < 0
  puts "#{name} ваш вес уже оптимальный"
end
