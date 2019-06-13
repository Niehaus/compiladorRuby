#!/usr/bin/env python3
# -*- coding: utf-8 -*-
x = 1
y = 10
a = 2
z = 1000
while y > x:
    y = y - 1
    x = x * 2
    z = z / x
print("Valor da variável x: " + str(x))
print("Valor da variável z: " + str(z))
print(str(x / z - y))
