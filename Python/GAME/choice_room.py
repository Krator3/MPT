import time
import ui
import rooms
import inventory
import fight_guard
import corridor

inventory = inventory.inventory

def room1():
    print("Вы заглянули в первую комнату, которая оказалась компьютерным офисом.")
    time.sleep(1)

    ir = rooms.room1.get('items', [])
    ui.print_header("Выберите, что взять:")
    ui.print_menu(tuple(ir))
    item_choice = ui.get_user_choice(len(ir))
    selected_item = ir[item_choice - 1]
    inventory.add_item(selected_item)
    ui.print_message(f'Предмет "{selected_item}" был добавлен в ваш инвентарь')

    if selected_item == "Флешка с данными о сотрудниках":
        print("СРАБОТАЛА СИГНАЛИЗАЦИЯ! ОХРАНА УЖЕ В ПУТИ!")
        ui.print_header("Что будешь делать?")
        options = ("Использовать карту доступа", "Битва с охраной")
        ui.print_menu(options)
        item_choice = ui.get_user_choice(len(options))
        selected_item = options[item_choice - 1]
        if selected_item == "Использовать карту доступа":
            check = inventory.has_item("Карта доступа")
            if check == False:
                print("У вас ее нет!")
                time.sleep(1.5)
                print("Вы пытаетесь спастись бегством и бежите в коридор.")
                time.sleep(2)
                print("Однако охрана нагоняет вас и вам остается только драка...")
                time.sleep(3)
                fight_guard.fight(fight_guard.player, fight_guard.guard)
            else:
                print("Карта доступа подошла и с ее помощью вы смогли отключить сигнализацию.\nОхрана не пришла.")
        else:
            fight_guard.fight(fight_guard.player, fight_guard.guard)
        

def room2():
    print("Вы заглянули во вторую комнату.\nПохоже тут живут администраторы организации.")
    time.sleep(1)

    ir = rooms.room2.get('items', [])
    ui.print_header("Выберите, что взять:")
    ui.print_menu(tuple(ir))
    item_choice = ui.get_user_choice(len(ir))
    selected_item = ir[item_choice - 1]
    inventory.add_item(selected_item)
    ui.print_message(f'Предмет "{selected_item}" был добавлен в ваш инвентарь')

def choose_door():
    i = 1
    while True:
        if i == 1:
            ui.print_header("Куда пойти?")
            options = ("Первая комната", "Вторая комната", "Уйти в коридор")
            ui.print_menu(options)
            choice = ui.get_user_choice(len(options))
        
            if choice == 1:
                room1()
            elif choice == 2:
                room2()
            else:
                corridor.corridor()
        i += 1
        
        # После выхода из комнаты предложить вернуться или уйти
        ui.print_header("Что дальше?")
        next_options = ("Пойти в другую комнату", "Выйти в коридор")
        ui.print_menu(next_options)
        next_choice = ui.get_user_choice(len(next_options))
        
        if next_choice == 1:
            if choice == 1:
                room2()
            elif choice == 2:
                room1()
        elif next_choice == 2:
            corridor.corridor()
        # Если выбрали пойти в другую комнату, цикл повторится

        if i == 2:
            print("Вы обыскали все комнаты и решили незаметно уйти в коридор.")
            corridor.corridor()
