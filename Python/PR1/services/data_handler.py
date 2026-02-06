import os
from models.book import Book
from models.user import User
from models.librarian import Librarian

class DataHandler:
    def save_data(self, books, users, librarians): # Файлы создаются в текущей рабочей директории
        with open('books.txt', 'w', encoding='utf-8') as f:
            for book in books.values():
                status = '1' if book.is_available else '0'
                f.write(f"{book.title}|{book.author}|{status}\n")
        
        with open('users.txt', 'w', encoding='utf-8') as f:
            for user in users.values():
                borrowed_books = ','.join(user.get_borrowed_books())
                f.write(f"{user.name}|{user._password}|{borrowed_books}\n")
        
        with open('librarians.txt', 'w', encoding='utf-8') as f:
            for librarian in librarians.values():
                f.write(f"{librarian.name}|{librarian._password}\n")
        
        print("✓ Данные сохранены")
    
    def load_data(self):
        books = {}
        users = {}
        librarians = {}
        
        if os.path.exists('books.txt'): # проверяет, существует ли указанный путь
            with open('books.txt', 'r', encoding='utf-8') as f:
                for line in f:
                    if line.strip():
                        title, author, status = line.strip().split('|')
                        is_available = status == '1'
                        books[title] = Book(title, author, is_available)
        
        if os.path.exists('users.txt'):
            with open('users.txt', 'r', encoding='utf-8') as f:
                for line in f:
                    if line.strip():
                        parts = line.strip().split('|')
                        if len(parts) >= 2:
                            name = parts[0]
                            password = parts[1]
                            user = User(name, password)
                            if len(parts) > 2 and parts[2]:
                                borrowed_books = parts[2].split(',')
                                for book_title in borrowed_books:
                                    if book_title in books:
                                        user.borrow_book(book_title)
                                        books[book_title].is_available = False
                            users[name] = user
        
        if os.path.exists('librarians.txt'):
            with open('librarians.txt', 'r', encoding='utf-8') as f:
                for line in f:
                    if line.strip():
                        parts = line.strip().split('|')
                        if len(parts) >= 2:
                            name = parts[0]
                            password = parts[1]
                            librarians[name] = Librarian(name, password)
        
        if not librarians:
            default_librarian = Librarian("admin", "admin123")
            librarians["admin"] = default_librarian
        
        return books, users, librarians