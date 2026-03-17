import os, pickle
from models.librarian import Librarian

class DataHandler:
    def save_data(self, books, users, librarians):
        with open('books.pkl', 'wb') as f:
            pickle.dump(books, f)
        
        with open('users.pkl', 'wb') as f:
            pickle.dump(users, f)
        
        with open('librarians.pkl', 'wb') as f:
            pickle.dump(librarians, f)
        
        print("✓ Данные сохранены")
    

    def load_data(self):
        books = {}
        users = {}
        librarians = {}
        if os.path.exists('books.pkl'):
            with open('books.pkl', 'rb') as f:
                books = pickle.load(f)
        
        if os.path.exists('users.pkl'):
            with open('users.pkl', 'rb') as f:
                users = pickle.load(f)
        
        if os.path.exists('librarians.pkl'):
            with open('librarians.pkl', 'rb') as f:
                librarians = pickle.load(f)
        
        if not librarians:
            default_librarian = Librarian("admin", "admin123")
            librarians["admin"] = default_librarian
        
        return books, users, librarians