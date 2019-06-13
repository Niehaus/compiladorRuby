#!/usr/bin/env python3
# -*- coding: utf-8 -*-
x = 1
y = 5
a = 2
z = 0
z = float(input("Digite o valor da variável z:"))
while y > 1:
    if y > 2:
        z = z / x
    x = x * 2
    y = y - 1
print("Valor da variável a: " + str(a))
print("Valor da variável x: " + str(x))
print("Valor da variável y: " + str(y))
print("Valor da variável z: " + str(z))
print(str(z >= x or a < 2.5 * y))
