import std/strformat, strutils

#..............................................................................
proc runSubmarine() =
    var
        position = 0
        depth = 0
        line: string

    let f = open("./input.txt")
    defer: f.close()

    while f.readLine(line):
        var
            s = line.strip().split(' ')
            direction = s[0]
            distance = parseInt(s[1])

        case direction:
            of "forward":
                position += distance

            of "up":
                depth -= distance

                if depth < 0:
                    echo("BREACH!!")

            of "down":
                depth += distance

        echo(&"{direction} {distance}")

    var hp = position * depth
    echo(&"position: {position}, depth: {depth}. total: {hp}")

#..............................................................................
runSubmarine()