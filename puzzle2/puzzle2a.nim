import std/strformat, strutils

#..............................................................................
proc runSubmarine() =
    var position = 0
    var depth = 0

    let f = open("./input.txt")
    defer: f.close()

    var line: string

    while f.readLine(line):
        var s = line.strip().split(' ')
        var direction = s[0]
        var distance = parseInt(s[1])
        echo(&"{direction} {distance}")

        case direction:
            of "forward":
                position += distance
            of "up":
                depth -= distance

                if depth < 0:
                    echo("BREACH!!")
            of "down":
                depth += distance

    var hp = position * depth
    echo(&"position: {position}, depth: {depth}. total: {hp}")

#..............................................................................
runSubmarine()