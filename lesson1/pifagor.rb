puts 'Введите стороны треугольника : '
puts 'Введите а:'
a = gets.to_i
puts 'Введите b:'
b = gets.to_i
puts 'Введите c:'
c = gets.to_i
if (a > b && a > c && a**2 == b**2 + c**2) || (b > a && b > c && b**2 == a**2 + c**2) || (c > a && c > b && c**2 == a**2 + b**2)
  puts "Треугольник прямоугольный"
elsif c == a && a == b
  puts 'Треугольник равносторонний'
elsif a == b || b == c || a == c
  puts 'Треугольник равнобедренный'
end

