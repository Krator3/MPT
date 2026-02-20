let expenses = [];
let nextId = 1;

// 1. Добавление расхода
function addExpense(title, amount, category) {
    if (!title || amount <= 0 || !category) {
        console.log('Ошибка: неверные данные');
        return;
    }
    
    const expense = {
        id: nextId++,
        title: title,
        amount: amount,
        category: category
    };
    
    expenses.push(expense);
    console.log(`Добавлено: ${title} - ${amount} руб. (${category})`);
}

// 2. Вывод всех расходов
function printAllExpenses() {
    console.log('\n=== ВСЕ РАСХОДЫ ===');
    if (expenses.length === 0) {
        console.log('Расходов нет');
    } else {
        for (let exp of expenses) {
            console.log(`${exp.id}. ${exp.title}: ${exp.amount} руб. (${exp.category})`);
        }
    }
}

// 3. Подсчёт общего баланса
function getTotalAmount() {
    if (expenses.length === 0) {
        console.log('\nРасходов нет');
        return 0;
    }
    
    let total = 0;
    
    console.log('\nЧЕК:');
    console.log('------------------');
    
    for (let exp of expenses) {
        console.log(`${exp.title}: ${exp.amount} руб.`);
        total += exp.amount;
    }
    
    console.log('------------------');
    console.log(`$$$ ВСЕГО: ${total} руб.`);
    console.log(`Количество покупок: ${expenses.length}`);
    
    return total;
}

// 4. Фильтрация по категории
function getExpensesByCategory(category) {
    console.log(`\n=== РАСХОДЫ НА КАТЕГОРИЮ "${category.toUpperCase()}" ===`);
    let total = 0;
    let found = false;
    
    for (let exp of expenses) {
        if (exp.category.toLowerCase() === category.toLowerCase()) {
            console.log(`${exp.title}: ${exp.amount} руб.`);
            total += exp.amount;
            found = true;
        }
    }
    
    if (!found) {
        console.log('Расходов нет');
    } else {
        console.log(`Итого: ${total} руб.`);
    }
    
    return { expenses: expenses.filter(e => e.category.toLowerCase() === category.toLowerCase()), total };
}

// 5. Поиск расхода
function findExpenseByTitle(searchText) {
    console.log(`\n=== ПОИСК ПО ЗАПРОСУ "${searchText}" ===`);
    
    let found = null;
    for (let exp of expenses) {
        if (exp.title.toLowerCase().includes(searchText.toLowerCase())) {
            found = exp;
            console.log(`Найдено: ${found.title} - ${found.amount} руб. (${found.category})`);
            break;
        }
    }
    
    if (!found) {
        console.log('Ничего не найдено');
    }
    
    let answer = prompt('Хотите добавить новый расход? (да/нет):');
    
    if (answer.toLowerCase() === 'да') {
        let newTitle = prompt('Введите название:');
        let newAmount = parseFloat(prompt('Введите сумму:'));
        let newCategory = prompt('Введите категорию:');
        
        if (newTitle && newAmount > 0 && newCategory) {
            addExpense(newTitle, newAmount, newCategory);
        } else {
            console.log('Ошибка: неверные данные');
        }
    }
    
    return found;
}

// 6. Удаление расхода по id
function deleteExpense(id) {
    if (id === undefined) {
        console.log('Ошибка: не указан ID');
        return false;
    }
    
    for (let i = 0; i < expenses.length; i++) {
        if (expenses[i].id === id) {
            console.log(`Удалено: ${expenses[i].title}`);
            expenses.splice(i, 1);
            return true;
        }
    }
    console.log(`ID ${id} не найден`);
    return false;
}

// 7. Статистика по категориям
function showStats() {
    let stats = {};
    let total = 0;
    
    for (let exp of expenses) {
        stats[exp.category] = (stats[exp.category] || 0) + exp.amount;
        total += exp.amount;
    }
    
    console.log('\n=== СТАТИСТИКА ПО КАТЕГОРИЯМ ===');
    if (expenses.length === 0) {
        console.log('Нет расходов');
    } else {
        for (let category in stats) {
            let percent = ((stats[category] / total) * 100).toFixed(1);
            console.log(`${category}: ${stats[category]} руб. (${percent}%)`);
        }
        console.log(`\nВсего покупок: ${expenses.length}\nОбщая стоимость: ${total} руб.`);
    }
}

function runApp() {
    let running = true;
    
    while (running) {
        console.log('\n' + '='.repeat(40));
        console.log('ТРЕКЕР РАСХОДОВ');
        console.log('='.repeat(40));
        console.log('1. Добавить расход');
        console.log('2. Показать все расходы');
        console.log('3. Показать общую сумму');
        console.log('4. Поиск по категории');
        console.log('5. Поиск по названию');
        console.log('6. Удалить расход по ID');
        console.log('7. Показать статистику');
        console.log('0. Выход');
        console.log('='.repeat(40));
        
        let choice = prompt('Выберите пункт меню:');
        
        switch (choice) {
            case '1':
                console.log('\n--- Добавление нового расхода ---');
                let title = prompt('Введите название:');
                let amount = parseFloat(prompt('Введите сумму:'));
                let category = prompt('Введите категорию:');
                
                addExpense(title, amount, category);
                break;
                
            case '2':
                printAllExpenses();
                break;
                
            case '3':
                getTotalAmount();
                break;
                
            case '4':
                console.log('\n--- Поиск по категории ---');
                let searchCategory = prompt('Введите категорию для поиска:');
                if (searchCategory) {
                    getExpensesByCategory(searchCategory);
                } else {
                    console.log('Категория не введена');
                }
                break;
                
            case '5':
                console.log('\n--- Поиск по названию ---');
                let searchTitle = prompt('Введите название для поиска:');
                if (searchTitle) {
                    findExpenseByTitle(searchTitle);
                } else {
                    console.log('Название не введено');
                }
                break;
                
            case '6':
                console.log('\n--- Удаление расхода ---');
                let idToDelete = parseInt(prompt('Введите ID расхода для удаления:'));
                if (!isNaN(idToDelete) && idToDelete > 0) {
                    deleteExpense(idToDelete);
                } else {
                    console.log('Неверный ID');
                }
                break;
                
            case '7':
                showStats();
                break;
                
            case '0':
                console.log('До свидания!');
                running = false;
                break;
                
            default:
                console.log('Неверный пункт меню. Пожалуйста, выберите от 0 до 7');
        }
    }
}

console.log('ДОБРО ПОЖАЛОВАТЬ В ТРЕКЕР РАСХОДОВ!');
runApp();