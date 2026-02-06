class UserOperations:
    def user_view_available_books(self, books):
        available_books = [book for book in books.values() if book.is_available]
        
        if not available_books:
            print("Нет доступных книг")
            return []
        
        print("\n" + "="*50, "ДОСТУПНЫЕ КНИГИ", "="*50)
        for i, book in enumerate(available_books, 1):
            print(f"{i:3}. {book.title:30} - {book.author:20}")
        
        return available_books
    
    def user_borrow_book_by_number(self, books, users, user_name):
        available_books = self.user_view_available_books(books)
        
        if not available_books:
            return False
        
        try:
            choice = input("\nВведите номер книги для взятия (0 - отмена): ").strip()
            if choice == '0':
                return False
            
            book_num = int(choice)
            if 1 <= book_num <= len(available_books):
                book = available_books[book_num - 1]
                return self._process_book_borrowing(books, users, user_name, book.title)
            else:
                print("✗ Неверный номер книги")
                return False
                
        except ValueError:
            print("✗ Пожалуйста, введите число")
            return False
    
    def _process_book_borrowing(self, books, users, user_name, book_title):
        if user_name not in users:
            print("✗ Пользователь не найден")
            return False
        
        if book_title not in books:
            print("✗ Книга не найдена")
            return False
        
        book = books[book_title]
        user = users[user_name]
        
        if not book.is_available:
            print("✗ Книга уже выдана")
            return False
        
        if user.borrow_book(book_title):
            book.borrow()
            print(f"\n✓ Книга '{book_title}' выдана пользователю {user_name}")
            return True
        
        return False
    
    def user_return_book_by_number(self, books, users, user_name):
        if user_name not in users:
            print("✗ Пользователь не найден")
            return False
        
        user = users[user_name]
        borrowed_books = user.get_borrowed_books()
        
        if not borrowed_books:
            print(f"У пользователя {user_name} нет взятых книг")
            return False
        
        print("\n" + "="*50, "ВАШИ ВЗЯТЫЕ КНИГИ", "="*50)
        for i, book_title in enumerate(borrowed_books, 1):
            book = books[book_title]
            print(f"{i:3}. {book.title:30} - {book.author:20}")
        
        try:
            choice = input("\nВведите номер книги для возврата (0 - отмена): ").strip()
            if choice == '0':
                return False
            
            book_num = int(choice)
            if 1 <= book_num <= len(borrowed_books):
                book_title = borrowed_books[book_num - 1]
                return self._process_book_return(books, users, user_name, book_title)
            else:
                print("✗ Неверный номер книги")
                return False
                
        except ValueError:
            print("✗ Пожалуйста, введите число")
            return False
    
    def _process_book_return(self, books, users, user_name, book_title):
        user = users[user_name]
        
        if user.return_book(book_title):
            if book_title in books:
                books[book_title].return_book()
            print(f"✓ Книга '{book_title}' возвращена")
            return True
        else:
            print("✗ У пользователя нет этой книги")
            return False
    
    def user_view_borrowed_books(self, books, users, user_name):
        if user_name not in users:
            print("✗ Пользователь не найден")
            return
        
        user = users[user_name]
        borrowed_books = user.get_borrowed_books()
        
        if not borrowed_books:
            print(f"У пользователя {user_name} нет взятых книг")
            return
        
        print(f"\n" + "="*60)
        print(f"ВАШИ ВЗЯТЫЕ КНИГИ")
        print("="*60)
        
        for i, book_title in enumerate(borrowed_books, 1):
            book = books.get(book_title, None)
            if book:
                print(f"{i:3}. {book.title:30} - {book.author:20}")
            else:
                print(f"{i:3}. {book_title:30} - (книга удалена из системы)")