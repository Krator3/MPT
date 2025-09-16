def list_sort(lst):
    lst.sort(key=lambda x: abs(x), reverse=True) #key нужен для передачи значения на сортировку
    return lst

# Тест
print(list_sort([1, 5, 77, -4]))