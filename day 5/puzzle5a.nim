import
    strutils,
    std/strformat

const inputFileName = "./input.txt"
const maxRows = 1000
const maxCols = 1000
var ventMatrix: array[0..maxRows - 1, array[0..maxCols - 1, int]]

# .............................................................................
proc processData() =
    let input = open(inputFileName)
    defer: input.close()

    var
        line: string

    while input.readLine(line):
        let lineSegments = line.split(" -> ")
        
        let startStr = lineSegments[0].strip().split(",")
        let startX = parseInt(startStr[0])
        let startY = parseInt(startStr[1])
        
        let endStr = lineSegments[1].strip().split(",")
        let endX = parseInt(endStr[0])
        let endY = parseInt(endStr[1])

        if startX == endX or startY == endY:
            # echo &"Using {line}"

            for row in min(startY, endY)..max(startY, endY):
                for col in min(startX, endX)..max(startX, endX):
                    ventMatrix[row][col] += 1
        

# .............................................................................
processData()

# Check matrix for points where at least 2 lines overlap
var overlaps = 0

for row in 0..maxRows-1:
    for col in 0..maxCols-1 :
        let value = ventMatrix[row][col]

        if value >= 2:
            overlaps += 1

    #     if value == 0:
    #         stdout.write("  .")
    #     else:
    #         stdout.write(&"{ventMatrix[row][col]:3}")
    # stdout.write("\n")

echo &"Overlaps: {overlaps}"