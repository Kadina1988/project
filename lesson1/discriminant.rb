puts 'Ввести 3 коэффициента: a, b и c'
puts 'a'
a = gets.to_i
puts 'b'
b = gets.to_i
puts 'c'
c = gets.to_i
puts 'Вычисляем Дискриминант(d)'
d = b**2 - 4 * a * c
if d > 0
  c = Math.sqrt(d)
  x1 = (-b + c)/(2*a)
  x2 = (-b - c)/(2*a)
  puts x1
  puts x2
elsif d == 0
  x1 == x2
  x1 = x2 = -b/(2*a)
  puts x1
else
  puts "Корней нет"
end

