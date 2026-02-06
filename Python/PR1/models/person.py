from abc import ABC, abstractmethod

class Person(ABC):
    def __init__(self, name, password):
        self._name = name
        self._password = password
    
    @property
    def name(self):
        return self._name
    
    def check_password(self, password):
        return self._password == password
    
    @abstractmethod
    def display_info(self):
        pass