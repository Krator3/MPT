const users = [
  { id: 1, name: "Anna", age: 22, city: "Moscow", isActive: true },
  { id: 2, name: "Oleg", age: 17, city: "Kazan", isActive: false },
  { id: 3, name: "Ivan", age: 30, city: "Moscow", isActive: true },
  { id: 4, name: "Maria", age: 25, city: "Sochi", isActive: false }
];

// Задание 1. Фильтрация пользователей
function getActiveUsers(users) {
  return users.filter(user => user.isActive === true);
}

// Задание 2. Получение имён пользователей
const getUserNames = (users) => {
  return users.map(user => user.name);
};

// Задание 3. Поиск пользователя
function findUserById(users, id) {
  const foundUser = users.find(user => user.id === id);
  return foundUser || null;
}

// Задание 4. Подсчёт статистики
function getUsersStatistics(users) {
  const activeUsers = users.filter(user => user.isActive);
  const inactiveUsers = users.filter(user => !user.isActive);
  
  return {
    total: users.length,
    active: activeUsers.length,
    inactive: inactiveUsers.length
  };
}

// Задание 5. Средний возраст
function getAverageAge(users) {
  if (users.length === 0) return 0;
  
  const totalAge = users.reduce((sum, user) => sum + user.age, 0);
  return totalAge / users.length;
}

// Задание 6. Группировка пользователей по городу
function groupUsersByCity(users) {
  return users.reduce((grouped, user) => {
    if (!grouped[user.city]) {
      grouped[user.city] = [];
    }
    grouped[user.city].push(user);
    return grouped;
  }, {});
}

console.log("1. Активные пользователи:", getActiveUsers(users));
console.log("2. Имена пользователей:", getUserNames(users));
console.log("3. Пользователь с id=3:", findUserById(users, 3));
console.log("4. Статистика:", getUsersStatistics(users));
console.log("5. Средний возраст:", getAverageAge(users));
console.log("6. Группировка по городам:", groupUsersByCity(users));