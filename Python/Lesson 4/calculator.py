print("""Добро пожаловать в многофункциональный калькулятор!
Выберите тип операции:
1. Арифметические операторы (+, -, *, /, //, %, **)
2. Операторы сравнения (==, !=, >, <, >=, <=)
3. Логические операторы (and, or, not)
4. Побитовые операторы (&, |, ^, ~, <<, >>)
5. Операторы принадлежности (in, not in)
6. Операторы тождественности (is, is not)
""")

try:
    choice = int(input("Введите номер операции (1-6): "))

    if choice == 1:
        a = float(input("Введите первое число: "))
        b = float(input("Введите второе число: "))
        op = input("Введите арифметический оператор (+, -, *, /, //, %, **): ")
        if op == '+':
            print(f"Результат: {a + b}")
        elif op == '-':
            print(f"Результат: {a - b}")
        elif op == '*':
            print(f"Результат: {a * b}")
        elif op == '/':
            if b == 0:
                print("Ошибка: Деление на ноль!")
            else:
                print(f"Результат: {a / b}")
        elif op == '//':
            if b == 0:
                print("Ошибка: Деление на ноль!")
            else:
                print(f"Результат: {a // b}")
        elif op == '%':
            if b == 0:
                print("Ошибка: Деление на ноль!")
            else:
                print(f"Результат: {a % b}")
        elif op == '**':
            print(f"Результат: {a ** b}")
        else:
            print("Ошибка: Неверный оператор!")

    elif choice == 2:
        a = float(input("Введите первое значение: "))
        b = float(input("Введите второе значение: "))
        op = input("Введите оператор сравнения (==, !=, >, <, >=, <=): ")

        if op == '==':
            print(f"a == b: {a == b}")
        elif op == '!=':
            print(f"a != b: {a != b}")
        elif op == '>':
            print(f"a > b: {a > b}")
        elif op == '<':
            print(f"a < b: {a < b}")
        elif op == '>=':
            print(f"a >= b: {a >= b}")
        elif op == '<=':
            print(f"a <= b: {a <= b}")
        else:
            print("Ошибка: Неверный оператор!")

    elif choice == 3:
        op = input("Выберите операцию (and, or, not): ").lower()

        if op == "not":
            x = input("Введите True или False: ").lower() == "true"
            print(not x)

        elif op == "and" or op == "or":
            x = input("Введите первое значение (True или False): ").lower() == "true"
            y = input("Введите второе значение (True или False): ").lower() == "true"

            if op == "and":
                print(x and y)
            else:
                print(x or y)
        else:
            print("Неверная команда!")

    elif choice == 4:
        op = input("Введите побитовый оператор (&, |, ^, ~, <<, >>): ")
        if op == '~':
            a = int(input("Введите целое число: "))
            print(f"Результат: {~a}")
        elif op in ['&', '|', '^', '<<', '>>']:
            a = int(input("Введите первое целое число: "))
            b = int(input("Введите второе целое число: "))
            if op == '&':
                print(f"Результат: {a & b}")
            elif op == '|':
                print(f"Результат: {a | b}")
            elif op == '^':
                print(f"Результат: {a ^ b}")
            elif op == '<<':
                print(f"Результат: {a << b}")
            elif op == '>>':
                print(f"Результат: {a >> b}")
        else:
            print("Ошибка: Неверный оператор!")

    elif choice == 5:
        op = input("Введите оператор принадлежности (in, not in): ")
        box = input("Введите строку или список в формате [elem1, elem2]): ")

        if box[0] == '[' and box[-1] == ']':
            try:
                box_eval = eval(box)
            except:
                box_eval = box
        else:
            box_eval = box

        element = input("Введите элемент для проверки: ")
        if op == 'in':
            print(element in box_eval)

        elif op == 'not in':
            print(element not in box_eval)

        else:
            print("Ошибка: Неверный оператор!")

    elif choice == 6:
        print("P.S: Операторы тождественности сравнивают объекты (id), а не значения!.")
        op = input("Введите оператор (is, is not): ")
        a = int(input("Введите первое значение: "))
        b = int(input("Введите второе значение: "))

        if op == 'is':
            print(a is b)
        elif op == 'is not':
            print(a is not b)
        else:
            print("Ошибка: Неверный оператор!")
    else:
        print("Ошибка: Неверный выбор операции!")

except Exception as e:
    print(f"Произошла ошибка: {e}")