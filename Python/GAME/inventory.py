class Inventory:
    def __init__(self):
        self.items = set()

    def add_item(self, item):
        """Добавляет предмет в инвентарь"""
        self.items.add(item)
        return True

    def has_item(self, item):
        """Проверяет наличие предмета в инвентаре."""
        return item in self.items

inventory = Inventory()