from models.user import User

class Auth:
    def authenticate_librarian(self, librarians):
        print("\n--- АВТОРИЗАЦИЯ БИБЛИОТЕКАРЯ ---")
        
        name = input("Имя библиотекаря: ").strip()
        
        if name not in librarians:
            print("✗ Библиотекарь не найден")
            return None
        
        password = input("Пароль: ").strip()
        
        librarian = librarians[name]
        
        if librarian.check_password(password):
            print(f"✓ Авторизация успешна! Добро пожаловать, {name}!")
            return name
        else:
            print("✗ Неверный пароль")
            return None
    
    def authenticate_user(self, users, save_callback):
        print("\n--- ВХОД В СИСТЕМУ ---")
        print("1. Войти")
        print("2. Зарегистрироваться")
        
        choice = input("Ваш выбор (1-2): ").strip()
        
        if choice == '1':
            name = input("Имя пользователя: ").strip()
            
            if name not in users:
                print("✗ Пользователь не найден")
                return None
            
            password = input("Пароль: ").strip()
            
            user = users[name]
            
            if user.check_password(password):
                print(f"✓ Авторизация успешна! Добро пожаловать, {name}!")
                return name
            else:
                print("✗ Неверный пароль")
                return None
        
        elif choice == '2':
            print("\n--- РЕГИСТРАЦИЯ ---")
            name = input("Имя пользователя: ").strip()
            
            if name in users:
                print("✗ Пользователь с таким именем уже существует")
                return None
            
            password = input("Пароль: ").strip()
            
            users[name] = User(name, password)
            print(f"✓ Регистрация успешна! Добро пожаловать, {name}!")
            
            save_callback()
            return name
        
        else:
            print("✗ Неверный выбор")
            return None