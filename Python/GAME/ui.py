def print_header(title):
    """Печать заголовка с обрамлением"""
    print("=" * (len(title) + 4))
    print(f"  {title}  ")
    print("=" * (len(title) + 4))

def print_menu(options):
    """Печать меню с нумерацией"""
    for idx, option in enumerate(options, 1):
        print(f"{idx}. {option}")

def get_user_choice(num_options):
    """Получить выбор пользователя с проверкой"""
    while True:
        choice = input("Выберите опцию: ")
        if choice.isdigit() and 1 <= int(choice) <= num_options:
            return int(choice)
        else:
            print(f"Пожалуйста, введите число от 1 до {num_options}.")

def print_message(message):
    """Вывод информационного сообщения"""
    print(f"\n{message}\n")
