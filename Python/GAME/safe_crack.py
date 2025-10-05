import config
import time
import inventory

inventory = inventory.inventory

class SafeCrack:
    def __init__(self):
        self.secret_word = config.SECRET_WORD
        self.attempts = config.MAX_ATTEMPTS
        self.user_chars = []
        self.is_open = False

    def display_state(self):
        display = ''
        is_win = True
        for char in self.secret_word:
            if char in self.user_chars:
                display += char + ' '
            else:
                display += '* '
                is_win = False
        print(display.strip())
        return is_win

    def input_char(self):
        while True:
            user_char = input('\nВведите букву: ').lower()
            if len(user_char) == 1 and user_char.isalpha():
                if user_char not in self.user_chars:
                    self.user_chars.append(user_char)
                return user_char
            else:
                print("Пожалуйста, введите одну букву!")

    def play(self):
        print("Отгадайте слово, чтобы вскрыть сейф:")
        print('* ' * len(self.secret_word))

        while self.attempts > 0:
            user_char = self.input_char()
            is_win = self.display_state()

            if user_char not in self.secret_word:
                self.attempts -= 1
                print(f'Осталось попыток: {self.attempts}')

            if is_win:
                self.is_open = True
                text = ['Иван успешно вскрыл сейф и вернулся с ценными данными "Корифея".',
                        "Эту информацию передали правоохранительным органам, что привело к аресту ключевых фигур в организации."]
                if inventory.has_item("Флешка с данными о сотрудниках"):
                    text.append("Благодаря тому, что вы также смогли выкрасть информацию о сотрудниках, задержание произошло максимально быстро.")

                for i in text:
                    print(i)
                    time.sleep(2)
                exit()

        if not self.is_open:
            print("Попытки закончились!\nВзрыв через...")
            for i in range(3, 0, -1):
                time.sleep(1.5)
                print(f"{i}...")
                
            time.sleep(1.5)
            text = ("Тайные активисты, отправившие Ивана на задание, узнали, что их агент доблестно погиб, пытаясь взломать сейф.",
                    "С тех пор он стал иконой борьбы за правду в их узких кругах.",
                    'Однако в это время злодеи "Корифея" пользуются моментом, чтобы уничтожить все улики, из-за чего мир остался в неведении относительно истинной угрозы.')
            for i in text:
                print(i)
                time.sleep(2)
            exit()