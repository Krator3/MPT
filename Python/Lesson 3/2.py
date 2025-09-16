def change(lst):
    if len(lst) >= 2:
        lst[0], lst[-1] = lst[-1], lst[0]
        return lst
    else:
        print("Список должен содержать минимум два значения!")
        exit()

print(change([1, 2, 3]))
print(change([1]))