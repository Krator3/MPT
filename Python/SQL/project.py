from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, func
from sqlalchemy.orm import declarative_base, sessionmaker, relationship

engine = create_engine("sqlite:///library.db", echo=True)
print(engine)
Base = declarative_base()

class Author(Base):
    __tablename__ = "authors"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    birth_year = Column(Integer)

    books = relationship("Book", back_populates="author")

class Book(Base):
    __tablename__ = "books"

    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    year = Column(Integer)
    author_id = Column(Integer, ForeignKey("authors.id"))

    author = relationship("Author", back_populates="books")

Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

author1 = Author(name="Джордж Оруэлл", birth_year=1903)
author2 = Author(name="Дж.К. Роулинг", birth_year=1965)
author3 = Author(name="Харпер Ли", birth_year=1926)
session.add_all([author1, author2, author3])
session.commit()

book1 = Book(title="1984", year=1949, author_id=author1.id)
book2 = Book(title="Скотный двор", year=1945, author_id=author1.id)
book3 = Book(title="Гарри Поттер и философский камень", year=1997, author_id=author2.id)
book4 = Book(title="Гарри Поттер и Тайная комната", year=1998, author_id=author2.id)
book5 = Book(title="Убить пересмешника", year=1960, author_id=author3.id)
session.add_all([book1, book2, book3, book4, book5])
session.commit()

print("---------------------------------------")
print("Вывод всех авторов")
authors = session.query(Author).all()
for a in authors:
    print(f"Автор: {a.name}")
print("---------------------------------------")

print("Обновление автора")
author_to_update = session.query(Author).filter_by(name="Джордж Оруэлл").first()
if author_to_update:
    author_to_update.name = "Джордж Оруэлл (обновлено)"
    session.commit()
    print(f"Автор обновлён: {author_to_update.name}")
print("---------------------------------------")

print("Удаление книги")
book_to_delete = session.query(Book).filter_by(title="Скотный двор").first()
if book_to_delete:
    session.delete(book_to_delete)
    session.commit()
    print("Книга 'Скотный двор' удалена")
print("---------------------------------------")

print("Книги по году (от новых к старым)")
books_sorted = session.query(Book).order_by(Book.year.desc()).all()
for b in books_sorted:
    print(f"Книга: {b.title} ({b.year})")
print("---------------------------------------")

print("Книги после 1950 года")
old_books = session.query(Book).filter(Book.year > 1950).all()
for b in old_books:
    print(f"Книга: {b.title} ({b.year})")
print("---------------------------------------")

print("Поиск автора")
author_by_name = session.query(Author).filter_by(name="Харпер Ли").first()
if author_by_name:
    print(f"Найден автор: {author_by_name.name}, год рождения: {author_by_name.birth_year}")
print("---------------------------------------")

print("Количество книг")
book_count = session.query(func.count(Book.id)).scalar()
print(f"Всего книг: {book_count}")
print("---------------------------------------")

print("Первые 3 книги (алфавитно)")
first_three = session.query(Book).order_by(Book.title).limit(3).all()
for b in first_three:
    print(b.title)

session.close()