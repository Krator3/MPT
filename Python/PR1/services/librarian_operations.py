from models.book import Book
from models.user import User

class LibrarianOperations:
    def librarian_add_book(self, books, title, author):
        if title not in books:
            books[title] = Book(title, author)
            print(f"✓ Книга '{title}' добавлена")
            return True
        else:
            print("✗ Книга с таким названием уже существует")
            return False
    
    def librarian_remove_book(self, books, title):
        if title in books:
            if not books[title].is_available:
                print("✗ Нельзя удалить книгу, которая выдана читателю")
                return False
            
            del books[title]
            print(f"✓ Книга '{title}' удалена")
            return True
        else:
            print("✗ Книга не найдена")
            return False
    
    def librarian_register_user(self, users, name, password):
        if name not in users:
            users[name] = User(name, password)
            print(f"✓ Пользователь '{name}' зарегистрирован")
            return True
        else:
            print("✗ Пользователь с таким именем уже существует")
            return False
    
    def librarian_view_users(self, users):
        if not users:
            print("Нет зарегистрированных пользователей")
            return
        
        print("\n" + "="*50 + "СПИСОК ПОЛЬЗОВАТЕЛЕЙ" + "="*50)

        for i, user in enumerate(users.values(), 1):
            borrowed_count = len(user.get_borrowed_books())
            print(f"{i:3}. {user.name:20} (взято книг: {borrowed_count})")
    
    def librarian_view_books(self, books):
        if not books:
            print("В библиотеке нет книг")
            return []
        
        print("\n" + "="*60 + "СПИСОК ВСЕХ КНИГ" + "="*60)
        available_count = 0
        books_list = list(books.values())
        
        for i, book in enumerate(books_list, 1):
            print(f"{i:3}. {book}")
            if book.is_available:
                available_count += 1
        
        print(f"\nВсего книг: {len(books)}")
        print(f"Доступно: {available_count}")
        print(f"Выдано: {len(books) - available_count}")
        
        return books_list