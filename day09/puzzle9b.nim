import
    strutils,
    strformat,
    algorithm

const inputFileName = "input.txt"

type
    Point = tuple
        row: int
        col: int
        value: int

    Direction = enum
        Up = 0
        Down = 1
        Left = 2
        Right = 3
        All = 4

var pitPoints: seq[Point] = @[]

# -------------------------------------------------------------------------------------------------
proc readHeightMap(): seq[seq[int]] =
    var
        heightMap: seq[seq[int]]
        row: seq[int]

    echo "Reading height map..."

    heightMap = @[]

    for line in inputFileName.lines:
        row = @[]

        for c in line:
            row.add(parseInt($c))

        heightMap.add(row)

    return heightMap

# -------------------------------------------------------------------------------------------------
proc findLowPoints(heightMap: seq[seq[int]]): seq[Point] =
    var
        lowPoints: seq[Point] = @[]
        rows = heightMap.len
        cols = heightMap[0].len - 1
        isLowPoint: bool

    echo "Finding low points..."

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
                lowPoints.add((rowIndex, colIndex, point))

    return lowPoints


# -------------------------------------------------------------------------------------------------
proc checkPoint(point: Point, heightMap: seq[seq[int]], direction: Direction = All) =
    # Check point and all neighbors

    if point.value == 9:
        return

    if point in pitPoints:
        return

    pitPoints.add(point)

    # Check the neighbors above
    if direction != Down and point.row > 0:
        var pointAbove = heightMap[point.row - 1][point.col]
        checkPoint((point.row - 1, point.col, pointAbove), heightMap, Up)

    # Check the neighbors to the left
    if direction != Right and point.col > 0:
        var pointLeft = heightMap[point.row][point.col - 1]
        checkPoint((point.row, point.col - 1, pointLeft), heightMap, Left)

    # Check the neighbors to the right
    if direction != Left and point.col < heightMap[0].len - 1:
        var pointRight = heightMap[point.row][point.col + 1]
        checkPoint((point.row, point.col + 1, pointRight), heightMap, Right)

    # Check the neighbors below
    if direction != Up and point.row < heightMap.len - 1:
        var pointBelow = heightMap[point.row + 1][point.col]
        checkPoint((point.row + 1, point.col, pointBelow), heightMap, Down)

# -------------------------------------------------------------------------------------------------
when isMainModule:
    var
        heightMap = readHeightMap()
        lowPoints = findLowPoints(heightMap)
        pits: seq[int] = @[]
        pit = 0

    for point in lowPoints:
        inc pit
        stdout.write(&"Checking pit {pit}\r")

        pitPoints = @[]
        checkPoint(point, heightMap)
        pits.add(pitPoints.len)
        
    stdout.write("\rChecked all pits   \n")

    var result: int = 1

    for size in pits.sorted()[^3..^1]:
        result *= size

    echo &"Final Result: {result}"
