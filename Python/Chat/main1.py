import socket
import threading

def receive_messages(client_socket):
    while True:
        data = client_socket.recv(1024)
        if not data:
            break
        print(data.decode('utf-8'))

def send_messages(client_socket):
    while True:
        message = input()
        if message.lower() in ['exit', 'quit', 'q']:
            break
        client_socket.send(message.encode('utf-8'))

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('127.0.0.1', 5001))

print(client_socket.recv(1024).decode('utf-8'), end="")
name = input()
client_socket.send(name.encode('utf-8'))

threading.Thread(target=receive_messages, args=(client_socket,), daemon=True).start()
send_messages(client_socket)
client_socket.close()