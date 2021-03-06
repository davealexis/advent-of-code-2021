import
    strutils,
    std/strformat

const 
    inputFileName = "./input.txt"
    maxRows = 1000
    maxCols = 1000

var 
    ventMatrix: array[0..maxRows, array[0..maxCols, int]]

# .............................................................................
proc checkMatrix(): int =
    var overlaps = 0

    for row in 0..maxRows:
        for col in 0..maxCols :
            let value = ventMatrix[row][col]

            if value >= 2:
                overlaps += 1

    #         if value == 0:
    #             stdout.write("  .")
    #         else:
    #             stdout.write(&"{ventMatrix[row][col]:3}")
    #     stdout.write("\n")
    
    # echo "---------------"

    return overlaps

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
            # echo &"Using: {line}"
            for row in min(startY, endY)..max(startY, endY):
                for col in min(startX, endX)..max(startX, endX):
                    ventMatrix[row][col] += 1
        else:
            if min(startY, endY) - max(startY, endY) == min(startX, endX) - max(startX, endX):       
                # echo &"Using {line}"
                var 
                    colStep = 1
                    rowStep = 1

                colStep = if startX > endX: -1 else: 1
                rowStep = if startY > endY: -1 else: 1

                var
                    row = startY
                    col = startX

                while true:
                    ventMatrix[row][col] += 1
                    
                    if row == endY or col == endX:
                        break

                    col += colStep
                    row += rowStep
        
        # echo checkMatrix()

# .............................................................................
processData()

# Check matrix for points where at least 2 lines overlap
echo &"Overlaps: {checkMatrix()}"
