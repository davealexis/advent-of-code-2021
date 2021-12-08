from pathlib import Path

cwd = Path(__file__).parent

bitCount = 12
rcount = 0
bitsums = [0] * bitCount

with open(cwd / 'input.txt', 'r') as f:
    for line in f:
        bits = [int(b) for b in line.strip()]
        rcount += 1

        for i in range(bitCount):
            bitsums[i] += bits[i]

        print(bits, bitsums)

print('------------')
print('rcount:', rcount)
print(bitsums)
print('------------')
h = int(rcount / 2)
print('h:', h)
gamma = 0
epsilon = 0

gamabits = [1 if bit > h else 0 for bit in bitsums]
epsilonbits = [0 if bit > h else 1 for bit in bitsums]
print(gamabits)
print(epsilonbits)

for i in range(bitCount):
    gamma = (gamma << 1) + gamabits[i]
    epsilon = (epsilon << 1) + epsilonbits[i]

print(f'gamma: {gamma} epsilon: {epsilon}')
power = gamma * epsilon
print(f'power: {power}')


