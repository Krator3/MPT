name = input("Введите ваше имя: ")
age = int(input("Введите ваш возраст: "))
email = input("Введите вашу почту: ")
password = input("Введите ваш пароль: ")

if name == "":
    print("Имя некорректно!")
else:
    print(f"Здраствуйте, {name}!")

if age > 18 and age < 65:
    print("Отличный возраст!")
else:
    print("Тебе тут не место!")

if "@" in email:
    print("Почта принята")
else:
    print("А где '@' ?")

if len(password) < 8:
    print("Пароль плох!")
else:
    print("Пароль принят")
