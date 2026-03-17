from library_system import LibrarySystem

if __name__ == "__main__":
    system = LibrarySystem()
    
    if not system._books:
        system.librarian_add_book("Мастер и Маргарита", "Михаил Булгаков")
        system.librarian_add_book("Преступление и наказание", "Федор Достоевский")
        system.librarian_add_book("1984", "Джордж Оруэлл")
        system.librarian_add_book("Война и мир", "Лев Толстой")
        system.librarian_add_book("Евгений Онегин", "Александр Пушкин")
        system.save_data()
    
    try:
        system.run()
    except KeyboardInterrupt:
        print("\n\nПрограмма прервана пользователем")
        system.save_data()
    except Exception as e:
        print(f"\nПроизошла ошибка: {e}")
        system.save_data()