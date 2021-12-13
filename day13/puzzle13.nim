import
    strutils,
    sequtils,
    strformat

const inputFileName = "input.txt"
const puzzlePart = 2

type
    FoldTypes = enum
        FoldAlongX,
        FoldAlongY

    Point = tuple
        x: int
        y: int

    Fold = tuple
        foldType: FoldTypes
        position: int

var
    data: seq[Point] = @[]
    folds: seq[Fold] = @[]
    grid: seq[seq[bool]] = @[]
    finalGridDimensions: Point


# -----------------------------------------------------------------------------
proc loadInput() =
    for line in inputFileName.lines:
        if line.strip().len == 0:
            continue
        
        if line.strip().startswith("fold"):
            var foldInfo = line[10..^1].strip().split("=")

            case foldInfo[0]
                of "x":
                    folds.add((FoldAlongX, parseInt(foldInfo[1])))
                of "y":
                    folds.add((FoldAlongY, parseInt(foldInfo[1])))
                else:
                    echo "Unknown fold type: " & line

            continue

        var points = line.strip().split(",").map(parseInt)
        data.add((points[0], points[1]))

# -----------------------------------------------------------------------------
proc buildGrid() =
    var 
        maxX: int
        maxY: int

    for point in data:
        if point.x > maxX: maxX = point.x
        if point.y > maxY: maxY = point.y

    echo &"Max X: {maxX} Max Y: {maxY}"

    finalGridDimensions = (maxX + 1, maxY + 1)
        
    # We know the max values, so we can build the grid
    for y in 0..maxY:
        grid.add(@[])

        for x in 0..maxX:
            grid[y].add(false)

    for point in data:
        grid[point.y][point.x] = true

# -----------------------------------------------------------------------------
proc printGrid() =
    echo ""
    echo "-".repeat(finalGridDimensions.x) & "\n"
    
    for y in 0..finalGridDimensions.y:
        for x in 0..finalGridDimensions.x:
            if grid[y][x]:
                stdout.write "*"
            else:
                stdout.write " "
        echo ""

    echo "-".repeat(finalGridDimensions.x)
    
# -----------------------------------------------------------------------------
proc foldGrid(fold: Fold) =
    echo &"{fold.foldType} {fold.position}"

    if fold.foldType == FoldAlongX:
        finalGridDimensions.x = fold.position

        # Translate right side of grid to left side
        # Formula: foldPosition - (point.x - foldPosition)
        for y in 0..grid.len - 1:
            for x in fold.position..grid[y].len - 1:
                if grid[y][x]:
                    grid[y][fold.position - (x - fold.position)] = true
                    grid[y][x] = false
    else:
        finalGridDimensions.y = fold.position

        # Translate bottom of grid to top
        # Formula: foldPosition - (point.y - foldPosition)
        for y in fold.position..grid.len - 1:

            for x in 0..grid[y].len - 1:
                if grid[y][x]:
                    grid[fold.position  - (y - fold.position)][x] = true
                    grid[y][x] = false


# -----------------------------------------------------------------------------
proc processFolds() =
    if puzzlePart == 1:
        foldGrid(folds[0])
    else:
        for fold in folds:
            foldGrid(fold)

# -----------------------------------------------------------------------------
proc countDots() =
    var 
        count: int = 0
    
    for row in grid:
        for cell in row:
            if cell:
                count += 1

    echo &"Dots: {count}"

# -----------------------------------------------------------------------------
if isMainModule:
    loadInput()
    buildGrid()
    processFolds()
    printGrid()
    countDots()

