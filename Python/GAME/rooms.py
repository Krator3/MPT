def create_room(items=None):
    return {
        'items': items if items is not None else []
    }

def items_room(room):
    if not room['items']:
        return "В комнате нет предметов."
    desc = "В комнате есть следующие предметы:\n"
    for item in room['items']:
        desc += f" - {item}\n"
    return desc.strip()

room1 = create_room(items=["Флешка с данными о сотрудниках", "Удостоверение личности"])
room2 = create_room(items=["Записная книжка", "Карта доступа"])

proom1 = items_room(room1)
proom2 = items_room(room2)
