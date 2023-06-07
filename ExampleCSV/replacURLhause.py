import os

f = open("links1.csv", "r")
# print(f.read())
inhalt = f.read()

f2 = open("links2.csv", "a")
f2Inhalt = inhalt.replace("\n", ",")

f2.write(f2Inhalt)