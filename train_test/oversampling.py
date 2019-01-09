import sys
import argparse


def oversample(filename, times):
    with open(filename,'r') as r:
        lines = r.readlines()
    with open(filename + 'ov','w') as w:
        for line in lines:
            label = int(line.split()[0])
            mean = line.split()[22]
            mean = mean.split(':')[1]
            mean = float(mean)
            if label == 0 and mean >= 1:
                print('haha')
                i = 0
                for i in range(times):
                    i = i + 1
                    w.write(line)
            else:
                w.write(line)

if __name__ == "__main__":
    filename = sys.argv[1]
    oversample(filename,6)




