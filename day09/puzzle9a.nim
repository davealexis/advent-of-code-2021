import
    strutils,
    sequtils,
    sugar

const inputFileName = "input.txt"


# -------------------------------------------------------------------------------------------------
proc readHeightMap(): seq[seq[int]] =
    var
        heightMap: seq[seq[int]]
        row: seq[int]

    heightMap = @[]

    for line in inputFileName.lines:
        row = @[]

        for c in line:
            row.add(parseInt($c))

        heightMap.add(row)

    return heightMap

# -------------------------------------------------------------------------------------------------
proc findLowPoints(heightMap: seq[seq[int]]): seq[int] =
    var
        lowPoints: seq[int] = @[]
        rows = heightMap.len
        cols = heightMap[0].len - 1
        isLowPoint: bool

    for rowIndex in 0 ..< rows:
        for colIndex in 0 .. cols:
            # for each point, compare it to the neighbors in the grid
            var point = heightMap[rowIndex][colIndex]

            isLowPoint = true

            # Check the neighbors above
            if rowIndex > 0:
                var rowAbove = heightMap[rowIndex - 1]
                var startCol = max(colIndex - 1, 0)
                var endCol = min(colIndex + 1, cols)

                for v in rowAbove[startCol .. endCol]:
                    if v < point:
                        isLowPoint = false
                        break

            # Check the neighbors to the left
            if isLowPoint and colIndex > 0 and point > heightMap[rowIndex][colIndex - 1]:
                isLowPoint = false

            # Check the neighbors to the right
            if isLowPoint and colIndex < cols and point > heightMap[rowIndex][colIndex + 1]:
                isLowPoint = false

            # Check the neighbors below
            if isLowPoint and rowIndex < rows - 1:
                var rowBelow = heightMap[rowIndex + 1]
                var startCol = max(colIndex - 1, 0)
                var endCol = min(colIndex + 1, cols)

                for v in rowBelow[startCol .. endCol]:
                    if v < point:
                        isLowPoint = false
                        break

            if isLowPoint:
                lowPoints.add(point)

    return lowPoints

# -------------------------------------------------------------------------------------------------
if isMainModule:
    var heightMap = readHeightMap()
    var lowPoints = findLowPoints(heightMap)
    echo lowPoints.map(n => n + 1).foldl(a + b)