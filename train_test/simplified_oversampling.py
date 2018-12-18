def oversample(filename):
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
                for i in range(12):
                    i = i + 1
                    w.write(line)
            else:
                w.write(line)
file = 'STAT3.HeLa-S3'
file2 = 'STAT3.OCI'
file3 = 'STAT3.MCF-10A'
file4 = 'STAT3MD'
#oversample(file2)
#oversample(file3)
oversample(file4)


