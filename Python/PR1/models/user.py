from .person import Person

class User(Person):
    def __init__(self, name, password):
        super().__init__(name, password)
        self._borrowed_books = []
    
    def borrow_book(self, book_title):
        if book_title not in self._borrowed_books:
            self._borrowed_books.append(book_title)
            return True
        return False
    
    def return_book(self, book_title):
        if book_title in self._borrowed_books:
            self._borrowed_books.remove(book_title)
            return True
        return False
    
    def get_borrowed_books(self):
        return self._borrowed_books.copy()
    
    def display_info(self):
        print(f"Пользователь: {self._name}")
        if self._borrowed_books:
            print(f"Взятые книги: {', '.join(self._borrowed_books)}")
        else:
            print("Нет взятых книг")