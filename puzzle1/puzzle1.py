
with open('./puzzle1/input.txt', 'r') as f:
    data = int(f.readline())
    higher_readings = 0

    for reading in f:
        r = int(reading.strip())

        if r > data:
            higher_readings += 1

        data = r

print(higher_readings)
