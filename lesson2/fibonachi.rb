arr = [0]
f = 0
i = 0
a = 1

while  f < 100
f = i + a
a = f - a
i = f
arr << f
end

p arr
