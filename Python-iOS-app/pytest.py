import math

def sum(p1):
    count = len(p1)
    sum = 0
    for i in range(count):
        sum+=p1[i]
    print(sum)

def strsplit(str, patt):
    return str.split(patt)
