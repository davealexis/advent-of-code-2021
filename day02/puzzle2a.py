# Open and parse the input file
# Parse the input file into a list of instructions separated by space

position = 0
depth = 0
aim = 0

with open('./input.txt') as f:
    for line in f:
        direction, distance = line.split()
        distance = int(distance)
        print(f'{direction} {distance}')

        match direction:
            case 'forward':
                position += distance
                depth += aim * distance
            case 'up':
                # depth -= distance
                aim -= distance

                if depth < 0:
                    print("BREACH!!")
            case 'down':
                # depth += distance
                aim += distance

    hp = position * depth
    print(f'position: {position}, depth: {depth}, aim: {aim}. total: {hp}')
