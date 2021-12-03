inputFile = './input.txt'
buffer = [0, 0, 0]
bindex = 0

with open(inputFile, 'r') as f:
    higher_readings = 0
    last_reading = 999999

    for reading in f:
        buffer[bindex] = int(reading.strip())

        if len([r for r in buffer if r > 0]) == 3:
            s = sum(buffer)

            if s > last_reading:
                higher_readings += 1

            last_reading = s

        bindex = (bindex + 1) % 3

print(f'Higher readings: {higher_readings}')