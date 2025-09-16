from random import randint as r
from time import sleep as s
from os import system

while True:
    rand = r(1,10)
    try:
        answer = int(input("Введите число от 1 до 10: "))
    except:
        print("ВВОДИ ЦЕЛОЕ ЧИСЛО!")
    else:
        print("Загадываю число...")
        s(1)
        print("Сравниваю ответ...")
        s(1)
        print("БАРАБАННАЯ ДРОБЬ...")
        s(1)
        print("И....")
        s(1)
        if answer == rand:
            print("ПОБЕДА!")
            system('notify-send "Мои поздравления)"')
        else:
            print(f"Не угадал)\nПравильный ответ: {rand}")
