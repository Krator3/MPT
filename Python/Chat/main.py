import socket
import threading

clients = []
client_lock = threading.Lock()

def broadcast(message, sender_socket=None):
    with client_lock:
        for client in clients[:]:
            if client != sender_socket:
                try:
                    client.send(message)
                except:
                    if client in clients:
                        clients.remove(client)

def cl(client_socket, client_address):
    print(f"Клиент {client_address} подключен")
    
    client_socket.send("Введите ваше имя: ".encode('utf-8'))
    name = client_socket.recv(1024).decode('utf-8').strip()
    if not name:
        name = f"Аноним_{client_address[1]}"
    
    with client_lock:
        clients.append(client_socket)
    
    client_socket.send(f"Добро пожаловать в чат, {name}!".encode('utf-8'))
    broadcast(f"{name} присоединился к чату".encode('utf-8'), client_socket)
    
    while True:
        try:
            data = client_socket.recv(1024)
            if not data:
                break
            message = data.decode("utf-8")
            print(f"{name}: {message}")
            broadcast(f"{name}: {message}".encode('utf-8'), client_socket)
        except:
            break
    
    with client_lock:
        if client_socket in clients:
            clients.remove(client_socket)
    client_socket.close()
    print(f"{name} отключился")
    broadcast(f"{name} покинул чат".encode('utf-8'))

socket_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
socket_server.bind(("127.0.0.1", 5001))
socket_server.listen()
print("Сервер ждет подключения")

while True:
    client_socket, client_address = socket_server.accept()
    threading.Thread(target=cl, args=(client_socket, client_address), daemon=True).start()