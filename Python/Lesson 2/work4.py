# 1
favorite_fruits = ['Яблоко', 'Мандарин', 'Груша', 'Виноград', 'Манго']
print(favorite_fruits)

# 2
numbers = [10, 20, 30, 40, 50]
print(numbers[0])
print(numbers[1])
print(numbers[-1])

# 3
cars = ['BMW', 'Audi', 'Lada']
cars[cars.index('Lada')] = 'Mercedes'
print(cars)

# 4
cars.append('Toyota')
print(cars)

cars.insert(1, 'Honda')
print(cars)

cars.remove('BMW')
print(cars)

del cars[0] # или cars.pop(0)
print(cars)

cars.pop()
print(cars)

# 5
words = ['слово1', 'слово2', 'слово3', 'слово4']
print(len(words))
