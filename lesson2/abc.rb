abc = ('a'..'z')
array_abc = abc.to_a
vowels = ['a', 'e', 'y', 'u', 'o', 'i']
hash = {}

vowels.each do |leters|
  if array_abc.include?(leters)
    hash[leters] = array_abc.index(leters) + 1
  end
end
p hash

