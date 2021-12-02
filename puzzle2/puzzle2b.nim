import std/strformat, strutils

#..............................................................................
proc runSub() =
    let f = open("./input.txt")
    defer: f.close()

    var
        position = 0
        depth = 0
        aim = 0
        line: string

    while f.readLine(line):
        var
            s = line.strip().split(' ')
            direction = s[0]
            distance = parseInt(s[1])

        case direction:
            of "forward":
                position += distance
                depth += aim * distance

            of "up":
                # depth -= distance
                aim -= distance

                if depth < 0:
                    echo("BREACH!!")

            of "down":
                # depth += distance
                aim += distance

        echo(&"{direction} {distance} -->> Aim: {aim}  Position: {position} Depth: {depth}")

    var hp = position * depth
    echo(&"\nposition: {position}, depth: {depth}, aim: {aim}. total: {hp}")

#..............................................................................
runSub()