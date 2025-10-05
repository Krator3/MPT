import random
import time

class Colors:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    RESET = "\033[0m"

class Character:
    def __init__(self, name, hp, attack_min, attack_max, defense):
        self.name = name
        self.hp = hp
        self.attack_min = attack_min
        self.attack_max = attack_max
        self.defense = defense
    
    def attack(self, target):
        damage = random.randint(self.attack_min, self.attack_max) - target.defense
        damage = max(0, damage)  # Урон не может быть ниже 0
        target.hp -= damage
        target_hp_col = Colors.GREEN if target.hp > 20 else Colors.RED  # Зеленый, если хп >20, иначе красный
        print(f"{Colors.BLUE}{self.name}{Colors.RESET} наносит {Colors.YELLOW}{damage}{Colors.RESET} урона {Colors.BLUE}{target.name}{Colors.RESET}. (Осталось здоровья: {target_hp_col}{max(target.hp, 0)}{Colors.RESET})")
    
    def is_alive(self):
        return self.hp > 0

def fight(player, guard):
    print(f"{Colors.GREEN}Начинается бой! {Colors.BLUE}{player.name}{Colors.GREEN} против {Colors.BLUE}{guard.name}{Colors.GREEN}.{Colors.RESET}\n")
    
    while player.is_alive() and guard.is_alive():
        player.attack(guard)

        if not guard.is_alive():
            print(f"\n{Colors.GREEN}{guard.name} повержен!{Colors.RESET}")
            print("Иван одерживает верх, ловко уклоняясь от ударов.\nНо в процессе драки получает серьезное ранение.")
            break
        time.sleep(1)
        guard.attack(player)
        
        if not player.is_alive():
            print(f"\n{Colors.RED}{player.name} погиб!{Colors.RESET}")
            print("\nДрака закончилась не в вашу пользу.\nОхранники были сильнее и, не оставив никаких шансов, прикончили вас на месте.")
            exit()
        time.sleep(1)

player = Character(name="Иван Ковалев", hp=100, attack_min=13, attack_max=17, defense=5)
guard = Character(name="Охранник", hp=100, attack_min=16, attack_max=21, defense=2)
