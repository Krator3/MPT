from .person import Person

class Librarian(Person):
    def __init__(self, name, password):
        super().__init__(name, password)
    
    def display_info(self):
        print(f"Библиотекарь: {self._name}")