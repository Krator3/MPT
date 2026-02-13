const expenseTracker = { // Объект управления приложением (для пункта 6)
    expenses: [],
    nextId: 1,
    currentIndex: -1,

    // 1. Добавление расхода
    addExpense(title, amount, category) {
        if (!title || amount <= 0 || !category) {
            console.log('Ошибка: неверные данные');
            return;
        }
        
        const expense = {
            id: this.nextId++,
            title: title,
            amount: amount,
            category: category
        };
        
        this.expenses.push(expense);
        console.log(`Добавлено: ${title} - ${amount} руб. (${category})`);
    },
    
    // 2. Вывод всех расходов
    printAllExpenses() {
        console.log('\n=== ВСЕ РАСХОДЫ ===');
        if (this.expenses.length === 0) {
            console.log('Расходов нет');
        } else {
            for (let exp of this.expenses) {
                console.log(`${exp.id}. ${exp.title}: ${exp.amount} руб. (${exp.category})`);
            }
        }
    },
    
    // 3. Подсчёт общего баланса
    getTotalAmount() {
        if (this.expenses.length === 0) {
            console.log('\nРасходов нет');
            return 0;
        }
        
        let total = 0;
        
        console.log('\nЧЕК:');
        console.log('------------------');
        
        for (let exp of this.expenses) {
            console.log(`${exp.title}: ${exp.amount} руб.`);
            total += exp.amount;
        }
        
        console.log('------------------');
        console.log(`$$$ ВСЕГО: ${total} руб.`);
        console.log(`Количество покупок: ${this.expenses.length}`);
        
        return total;
    },
    
    // 4. Фильтрация по категории
    getExpensesByCategory(category) {
        console.log(`\n=== РАСХОДЫ НА КАТЕГОРИЮ "${category.toUpperCase()}" ===`);
        let total = 0;
        let found = false;
        
        for (let exp of this.expenses) {
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
    },

    // 5. Поиск расхода
    findExpenseByTitle(searchText) {
        console.log(`\n=== ПОИСК ПО ЗАПРОСУ "${searchText}" ===`);
        
        let found = null;
        for (let exp of this.expenses) {
            if (exp.title.toLowerCase().includes(searchText.toLowerCase())) {
                found = exp;
                console.log(`Найдено: ${found.title} - ${found.amount} руб. (${found.category})`);
                break; // берем первый найденный
            }
        }
        
        if (!found) {
            console.log('Ничего не найдено');
            return null;
        }
        
        let additionalInfo = prompt('Введите дополнительную информацию о расходе (или оставьте пустым):');
        
        if (additionalInfo && additionalInfo.trim() !== '') {
            found.title += ` (${additionalInfo.trim()})`; // Добавляем информацию к названию
            console.log(`Следующая информация добавлена: "${found.title}"`);
        } else {
            console.log('Дополнительная информация не добавлена');
        }
        
        return found;
    },
    
    // 6. Переключение между расходами
    nextExpense() {
        if (this.expenses.length === 0) {
            console.log('Нет расходов');
            return;
        }
        this.currentIndex = (this.currentIndex + 1) % this.expenses.length;
        let exp = this.expenses[this.currentIndex];
        console.log(`\nТекущий (${this.currentIndex + 1}/${this.expenses.length}): ${exp.title} - ${exp.amount} руб. (${exp.category})`);
        return exp;
    },
    
    previousExpense() {
        if (this.expenses.length === 0) {
            console.log('Нет расходов');
            return;
        }
        this.currentIndex = (this.currentIndex - 1 + this.expenses.length) % this.expenses.length;
        let exp = this.expenses[this.currentIndex];
        console.log(`\nТекущий (${this.currentIndex + 1}/${this.expenses.length}): ${exp.title} - ${exp.amount} руб. (${exp.category})`);
        return exp;
    },
    
    // 7.1 Удаление по id
    deleteExpense(id) {
        for (let i = 0; i < this.expenses.length; i++) {
            if (this.expenses[i].id === id) {
                console.log(`Удалено: ${this.expenses[i].title}`);
                this.expenses.splice(i, 1); // удаляет 1 элемент из массива по индексу i
                return true;
            }
        }
        console.log(`ID ${id} не найден`);
        return false;
    },
    
    // 7.2 Статистика по категориям
    showStats() {
        let stats = {};
        let total = 0;
        
        for (let exp of this.expenses) {
            if (!stats[exp.category]) {
                stats[exp.category] = 0;
            }
            stats[exp.category] += exp.amount;
            total += exp.amount;
        }
        
        console.log('\n=== СТАТИСТИКА ПО КАТЕГОРИЯМ ===');
        if (this.expenses.length === 0) {
            console.log('Нет расходов');
        } else {
            for (let category in stats) {
                let percent = ((stats[category] / total) * 100).toFixed(1); // процент категории от всех трат, 1 знак после запятой
                console.log(`${category}: ${stats[category]} руб. (${percent}%)`);
            }
            console.log(`\nВсего расходов: ${this.expenses.length}`);
            console.log(`Общая сумма: ${total} руб.`);
        }
    }
};

// Демонстрация работы
console.log('ТРЕКЕР РАСХОДОВ\n');

// Добавляем расходы
expenseTracker.addExpense('Обед', 350, 'еда');
expenseTracker.addExpense('Такси', 500, 'транспорт');
expenseTracker.addExpense('Ужин', 400, 'еда');
expenseTracker.addExpense('Книга', 800, 'образование');

console.log('-----------------------------------------------------')

// Выводим всё
expenseTracker.printAllExpenses();

console.log('-----------------------------------------------------')

// Общий баланс
expenseTracker.getTotalAmount();

console.log('-----------------------------------------------------')

// Фильтр по категории
expenseTracker.getExpensesByCategory('еда');

console.log('-----------------------------------------------------')

// Поиск
expenseTracker.findExpenseByTitle('Обед');
expenseTracker.findExpenseByTitle('Пицца');

console.log('-----------------------------------------------------')

// Переключение
expenseTracker.nextExpense();
expenseTracker.nextExpense();
expenseTracker.previousExpense();

console.log('-----------------------------------------------------')

// Удаление
expenseTracker.deleteExpense(2);
expenseTracker.printAllExpenses();

console.log('-----------------------------------------------------')

// Статистика
expenseTracker.showStats();