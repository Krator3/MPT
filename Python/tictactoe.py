import os, random, datetime, time

def save_statistics(result, board_size, mode, moves_count):
    try:
        os.makedirs('game_stat', exist_ok=True)
        with open(f'game_stat/statistics.txt', "a", encoding="utf-8") as f: f.write(f"Дата и время: {datetime.datetime.now()}\nРазмер поля: {board_size}x{board_size}\nРежим игры: {mode}\nКоличество ходов: {moves_count}\nРезультат: {result}\n" + "-" * 50 + "\n")
    except Exception as e: print(f"Ошибка при сохранении статистики: {e}")

def initialize_board(size): return [[' ' for _ in range(size)] for _ in range(size)]

def print_board(board):
    os.system('cls' if os.name == 'nt' else 'clear')
    print("=" * 30 + "\n     КРЕСТИКИ-НОЛИКИ\n" + "=" * 30)
    size = len(board)
    print("\n   " + "   ".join(str(i) for i in range(size)))
    
    for i in range(size):
        print(f"{i} " + "|".join([f" {cell} " for cell in board[i]]))
        if i < size - 1: print("  " + "---+" * (size - 1) + "---")

def check_winner(board, player):
    size = len(board)
    
    # Проверка строк и столбцов
    for i in range(size):
        if all(board[i][j] == player for j in range(size)) or all(board[j][i] == player for j in range(size)): return True
    
    # Проверка диагоналей
    if all(board[i][i] == player for i in range(size)) or all(board[i][size-1-i] == player for i in range(size)): return True
    
    return False

def is_board_full(board): return all(cell != ' ' for row in board for cell in row)

def get_player_move(board, player):
    size = len(board)
    
    while True:
        try:
            print(f"Игрок {player}, ваш ход!")
            row = int(input("Введите номер строки: "))
            col = int(input("Введите номер столбца: "))
            
            if 0 <= row < size and 0 <= col < size and board[row][col] == ' ': return row, col
            print(f"Координаты должны быть от 0 до {size-1} и клетка должна быть свободна!")
                
        except ValueError: print("Введите числа!")
        except Exception as e: print(f"Произошла ошибка: {e}")

def get_robot_move(board): return random.choice([(i, j) for i in range(len(board)) for j in range(len(board)) if board[i][j] == ' '])

def choose_game_mode():
    while True:
        try:
            choice = input("1 - Игра против друга\n2 - Игра против робота\nВыберите режим игры: ")
            if choice == '1': return "Против друга"
            if choice == '2': return "Против робота"
            print("Пожалуйста, введите 1 или 2!")
        except Exception as e: print(f"Произошла ошибка: {e}")

def get_board_size():
    while True:
        try:
            size = int(input("Введите размер игрового поля (3-9): "))
            if 3 <= size <= 9: return size
            print("Размер поля должен быть от 3 до 9!")
        except ValueError: print("Пожалуйста, введите число!")
        except Exception as e: print(f"Произошла ошибка: {e}")

def play_game():
    try:
        board_size = get_board_size()
        game_mode = choose_game_mode()
        
        current_player = random.choice(['X', 'O'])
        
        board = initialize_board(board_size)
        moves_count = 0
        
        while True:
            print_board(board)
            
            if game_mode == "Против друга" or current_player == 'X':  row, col = get_player_move(board, current_player)
            else:
                row, col = get_robot_move(board)
                print(f"Робот поставил {current_player} на позицию ({row}, {col})")
                time.sleep(1.5)
            
            board[row][col] = current_player
            moves_count += 1
            
            if check_winner(board, current_player):
                print_board(board)
                result = f"Победил {current_player}"
                print(f"\n{result}!")
                save_statistics(result, board_size, game_mode, moves_count)
                break
            
            if is_board_full(board):
                print_board(board)
                result = "Ничья"
                print(f"\n{result}!")
                save_statistics(result, board_size, game_mode, moves_count)
                break
            
            current_player = 'O' if current_player == 'X' else 'X'
    except KeyboardInterrupt:
        print("\nИгра прервана!")
        return

def ask_play_again():
    while True:
        try:
            choice = input("\nХотите сыграть еще раз? (да/нет): ").lower().strip()
            if choice in ['да', 'д', 'yes', 'y']: return True
            elif choice in ['нет', 'н', 'no', 'n']: return False
            else: print("Пожалуйста, введите ответ!")
        except KeyboardInterrupt:
            print("\nИгра прервана пользователем")
            return False
        except Exception as e:
            print(f"Произошла ошибка: {e}")
            return False

if __name__ == "__main__":    
    while True:
        play_game()
        if not ask_play_again():
            print("Спасибо за игру! До свидания!")
            break