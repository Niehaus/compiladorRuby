q = 123
b = 29
d = 21
b = 0
while b < 10:
    a = (b + 20) * c
    b = b + 1
c = 0
while c < 10:
    if a < b:
        a = (b + 20) * (c + d)
        a = (a / b)
        print("Valor da variável " : str(a))
        b = a + 2
    else:
        a = 40
    c = c + 1
