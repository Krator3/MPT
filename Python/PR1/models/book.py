class Book:
    def __init__(self, title, author, is_available=True):
        self._title = title
        self._author = author
        self._is_available = is_available
    
    @property
    def title(self):
        return self._title
    
    @property
    def author(self):
        return self._author
    
    @property
    def is_available(self):
        return self._is_available
    
    @is_available.setter
    def is_available(self, value):
        self._is_available = value
    
    def borrow(self):
        if self._is_available:
            self._is_available = False
            return True
        return False
    
    def return_book(self):
        self._is_available = True
    
    def __str__(self):
        status = "✓ Доступна" if self._is_available else "✗ Выдана"
        return f"{self._title} - {self._author} [{status}]"