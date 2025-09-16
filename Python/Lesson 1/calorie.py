calorie_milk = 20
calorie_butter = 50
calorie_apple = 100

print("Мой друг, давай посчитаем калории")

eatmilk = int(input("Сколько мл молока ты выпил?\n"))
eatbutter = int(input("Сколько гр масла ты съел?\n"))
eatapple = int(input("Сколько гр яблока ты съел?\n"))

print(f"Ты съел {eatbutter*calorie_butter + eatapple*calorie_apple + eatmilk*calorie_milk}")