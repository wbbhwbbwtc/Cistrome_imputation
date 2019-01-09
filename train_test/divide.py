import sys
import argparse
from random

def main():
    with open('samples','r') as r:
        lines = r.readlines()
    l_set1 = []
    l_set2 = []
    for x in lines:
        if random.random() <= p:
            l_set1.append(x)
        else:
            l_set2.append(x)

    with open('train_data','w') as w1:
        for l in l_set1:
            w1.write(l)
    with open('test_data','w') as w1:
        for l in lines:
            w2.write(l)


if __name__ == "__main__":
    main()