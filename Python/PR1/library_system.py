from services.data_handler import DataHandler
from services.librarian_operations import LibrarianOperations
from services.user_operations import UserOperations
from services.auth import Auth

class LibrarySystem:
    def __init__(self):
        self._books = {}
        self._users = {}
        self._librarians = {}
        self._current_user = None
        
        self.data_handler = DataHandler()
        self.librarian_ops = LibrarianOperations()
        self.user_ops = UserOperations()
        self.auth = Auth()
        
        self.load_data()
    
    def save_data(self):
        self.data_handler.save_data(self._books, self._users, self._librarians)
    
    def load_data(self):
        self._books, self._users, self._librarians = self.data_handler.load_data()
    
    def librarian_add_book(self, title, author):
        return self.librarian_ops.librarian_add_book(self._books, title, author)
    
    def librarian_remove_book(self, title):
        return self.librarian_ops.librarian_remove_book(self._books, title)
    
    def librarian_register_user(self, name, password):
        return self.librarian_ops.librarian_register_user(self._users, name, password)
    
    def librarian_view_users(self):
        self.librarian_ops.librarian_view_users(self._users)
    
    def librarian_view_books(self):
        return self.librarian_ops.librarian_view_books(self._books)
    
    def user_view_available_books(self):
        return self.user_ops.user_view_available_books(self._books)
    
    def user_borrow_book_by_number(self, user_name):
        return self.user_ops.user_borrow_book_by_number(self._books, self._users, user_name)
    
    def user_return_book_by_number(self, user_name):
        return self.user_ops.user_return_book_by_number(self._books, self._users, user_name)
    
    def user_view_borrowed_books(self, user_name):
        self.user_ops.user_view_borrowed_books(self._books, self._users, user_name)
    
    def authenticate_librarian(self):
        return self.auth.authenticate_librarian(self._librarians)
    
    def authenticate_user(self):
        return self.auth.authenticate_user(self._users, self.save_data)
    
    def run(self):
        print("\n" + "="*50, "СИСТЕМА УПРАВЛЕНИЯ БИБЛИОТЕКОЙ", "="*50)
        while True:
            print("\nГЛАВНОЕ МЕНЮ")
            print("1. Войти как библиотекарь")
            print("2. Войти как пользователь")
            print("3. Выход")
            
            choice = input("Ваш выбор (1-3): ").strip()
            if choice == '1':
                self.librarian_menu()
            elif choice == '2':
                self.user_menu()
            elif choice == '3':
                self.save_data()
                print("\nПрограмма завершена!")
                break
            else:
                print("✗ Неверный выбор. Попробуйте снова.")
    
    def librarian_menu(self):
        print("\n" + "="*50)
        print("РЕЖИМ БИБЛИОТЕКАРЯ")
        print("="*50)
        
        librarian_name = self.authenticate_librarian()
        if not librarian_name:
            return
        
        self._current_user = self._librarians[librarian_name]
        
        while True:
            print("\n--- МЕНЮ БИБЛИОТЕКАРЯ ---")
            print("1. Добавить новую книгу")
            print("2. Удалить книгу из системы")
            print("3. Зарегистрировать нового пользователя")
            print("4. Просмотреть список всех пользователей")
            print("5. Просмотреть список всех книг")
            print("6. Вернуться в главное меню")
            
            choice = input("Ваш выбор (1-6): ").strip()
            
            if choice == '1':
                print("\n--- ДОБАВЛЕНИЕ КНИГИ ---")
                title = input("Введите название книги: ").strip()
                author = input("Введите автора книги: ").strip()
                self.librarian_add_book(title, author)
                self.save_data()
            
            elif choice == '2':
                print("\n--- УДАЛЕНИЕ КНИГИ ---")
                books_list = self.librarian_view_books()
                if books_list:
                    try:
                        choice = input("\nВведите номер книги для удаления (0 - отмена): ").strip()
                        if choice != '0':
                            book_num = int(choice)
                            if 1 <= book_num <= len(books_list):
                                book = books_list[book_num - 1]
                                if self.librarian_remove_book(book.title):
                                    self.save_data()
                            else:
                                print("✗ Неверный номер книги")
                    except ValueError:
                        print("✗ Пожалуйста, введите число")
            
            elif choice == '3':
                print("\n--- РЕГИСТРАЦИЯ ПОЛЬЗОВАТЕЛЯ ---")
                name = input("Введите имя нового пользователя: ").strip()
                password = input("Введите пароль для пользователя: ").strip()
                
                if self.librarian_register_user(name, password):
                    self.save_data()
            
            elif choice == '4':
                self.librarian_view_users()
            
            elif choice == '5':
                self.librarian_view_books()
            
            elif choice == '6':
                print("Выход из текущей учетной записи...")
                break
            
            else:
                print("✗ Неверный выбор. Попробуйте снова.")
    
    def user_menu(self):
        print("\n" + "="*50, "РЕЖИМ ПОЛЬЗОВАТЕЛЯ", "="*50)
        
        user_name = self.authenticate_user()
        if not user_name:
            return
        
        self._current_user = self._users[user_name]
        
        while True:
            print(f"\n--- МЕНЮ ПОЛЬЗОВАТЕЛЯ ({user_name}) ---")
            print("1. Просмотреть доступные книги")
            print("2. Взять книгу")
            print("3. Вернуть книгу")
            print("4. Просмотреть список взятых книг")
            print("5. Вернуться в главное меню")
            
            choice = input("Ваш выбор (1-5): ").strip()
            
            if choice == '1':
                self.user_view_available_books()
            
            elif choice == '2':
                print("\n--- ВЗЯТИЕ КНИГИ ---")
                if self.user_borrow_book_by_number(user_name):
                    self.save_data()
            
            elif choice == '3':
                print("\n--- ВОЗВРАТ КНИГИ ---")
                if self.user_return_book_by_number(user_name):
                    self.save_data()
            
            elif choice == '4':
                self.user_view_borrowed_books(user_name)
            
            elif choice == '5':
                print("Выход из текущей учетной записи...")
                break
            
            else:
                print("✗ Неверный выбор. Попробуйте снова.")