import
    strutils,
    std/strformat,
    sequtils,
    sugar

const inputFileName = "input.txt"

type
    Location = tuple
        row: int
        col: int

    Direction = enum
        Up = 0
        Down = 1
        Left = 2
        Right = 3
        All = 4

var
    octopi: array[0..9, array[0..9, int]]
    flashed: seq[Location]
    needFlash: seq[Location]
    totalFlashes: int

# -----------------------------------------------------------------------------
proc getPod(): array[0..9, array[0..9, int]] =
    var
        pod: array[0..9, array[0..9, int]]

    let input = open(inputFileName)

    for row in 0..9:
        let line = input.readline

        for col in 0..9:
            pod[row][col] = parseInt($line[col])

    return pod

# -----------------------------------------------------------------------------
proc printPod(label: string, indent: int = 1) =
    echo &"\n{' '.repeat(indent * 4)}---- {label} ----"

    for row in octopi:
        stdout.write &"\n{' '.repeat(indent * 4)}"

        for col in row:
            stdout.write &"{col:>2} "

    echo "\n"

# -----------------------------------------------------------------------------
proc mark() =
    while needFlash.len > 0:
        let loc = needFlash[0]  
        needFlash.del(0)

        if loc in flashed:
            continue  # already flashed

        flashed.add(loc)

        for r in -1..1:
            var  row = loc.row + r

            if row < 0 or row > 9: continue

            for c in -1..1:
                var col = loc.col + c

                if r == 0 and c == 0: continue
                if col < 0 or col > 9: continue
                if octopi[row][col] == 0: continue

                # stdout.write &"    [{row}, {col}] "
                octopi[row][col] += 1

                if octopi[row][col] > 9:
                    needFlash.add((row, col))

                # printPod(&"Marked ({row},{col})")
    
# -----------------------------------------------------------------------------
proc sweep() =
    for row in 0..9:
        for col in 0..9:
            if octopi[row][col] >= 10:
                octopi[row][col] = 0

# -----------------------------------------------------------------------------
proc stepTopuses() =
    var
        rows = octopi.len
        cols = octopi[0].len

    # Increase energy level of the octupuses recursively until there are no more energy light bursts
    for row in 0 ..< rows:
        for col in 0 ..< cols:
            octopi[row][col] += 1

            if octopi[row][col] >= 10:
                needFlash.add((row, col))

    # printPod("After Increment")

    mark()

    # printPod("After Mark")

    sweep()

    # printPod("After Sweep")

# -----------------------------------------------------------------------------
if isMainModule:
    octopi = getPod()

    echo "Initial state:"
    for row in octopi:
        for col in row:
            stdout.write &"{col:>2} "
        echo ""

    for generation in 1..1000:
        echo &"\n------- Generation {generation:-3} -------"
        stepTopuses()
        
        echo "------------------------------"
        for row in octopi:
            for col in row:
                stdout.write &"{col:>2} "
            echo ""
        
        # echo &"Flash count: {flashed.len}"

        totalFlashes += flashed.len
        flashed = @[]

        # Find the generation in which the octopuses all flash at the same time
        var allFlash = true

        for row in octopi:
            for col in row:
                if col != 0:
                    allFlash = false
                    break

            if not allFlash: break

        if allFlash:
            echo &"\nAll octopuses flash at the same time in generation {generation}!"
            break

    echo &"\nTotal Flashes: {totalFlashes}"