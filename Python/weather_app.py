import requests

API_KEY = '5e777c63a0b33f98e07810d3158e8b4b'

def get_weather(city):
    try:
        url = f'https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric&lang=ru'
        
        response = requests.get(url, timeout=5)

        data = response.json()
        print(f"Город: {data['name']}\nТемпература: {data['main']['temp']}\nОписание погоды: {data['weather'][0]['description']}\nВлажность: {data['main']['humidity']}\nВетер: {data['wind']['speed']}")
    
    except requests.Timeout:
        print('Таймаут 5 секунд')

    except:
        if response.status_code == 401:
            print('Неверный ключ API')
        elif response.status_code == 404:
            print('Город не найден')
        else:
            print('Неизвестная ошибка')

if __name__ == '__main__':
    get_weather('Moscow')