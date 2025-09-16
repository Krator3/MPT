def useless(lst):
    return max(lst) / len(lst)

# Тест
print(round(useless([1, 5, 2]), 2))