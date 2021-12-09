import
    std/[sequtils, sugar, strformat],
    strutils,
    sugar

const inputFile = "test-input.txt"

proc findDigits() =
    let inputFile = open(inputFile)
    defer: inputFile.close()

    var line: string
    var digitCount = 0

    while inputFile.readline(line):
        echo line

        let digitsPart = line.split(" | ")[1].split(" ")

        for i in digitsPart:
            case i.len
                of 2:
                    echo &"     {i} (1) could be segments 3 and 6"
                of 3:
                    echo &"     {i} (7) could be segments 1, 3, 6"
                of 4:
                    echo &"     {i} (4) could be segments 2, 3, 4 and 6"
                of 7:
                    echo &"     {i} (8) could be all segments"
                else:
                    echo &"     {i} ??"

    
findDigits()
