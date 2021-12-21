import
    strformat,
    strutils,
    os,
    terminal

var 
    maxHeight = 0
    ivCount = 0

let 
    inputFileName = paramStr(1)
    input = readFile(inputFileName)
            .strip()
            .split(": ")[1]
            .split(", ")
    xIn = input[0].split("=")[1].split("..")
    yIn = input[1].split("=")[1].split("..")
    targetX1 = parseInt(xIn[0])
    targetX2 = parseInt(xIn[1])
    targetY1 = parseInt(yIn[0])
    targetY2 = parseInt(yIn[1])

var
    progressIndex = 0
    spinners = ['|', '/', '-', '\\', '-']

# ------------------------------------------------------------------------------
proc testProbeTrajectories() =
    var testCount = 0

    for testX in 0..1000:
        progressIndex = (progressIndex + 1) mod spinners.len
        eraseline()
        stdout.write &"\rChurning ... {spinners[progressIndex]}"

        for testY in -1000..1000:
            var 
                highY = 0
                x = 0
                y = 0
                xVelocity = testX
                yVelocity = testY
                hit: bool = false

            for t in 0..1000:
                testCount += 1
                x += xVelocity
                y += yVelocity
                highY = max(highY, y)

                if xVelocity > 0:
                    xVelocity -= 1
                elif xVelocity < 0:
                    xVelocity += 1

                yVelocity -= 1

                if targetX1 <= x and x <= targetX2 and targetY1 <= y and y <= targetY2:
                    maxHeight = max(maxHeight, highY)
                    hit = true

                # Check if we're out of bounds. No need to keep going if we already missed.
                if y < targetY1:
                    break

            if hit:
                ivCount += 1
                hit = false

    eraseline()
    echo &"Max Height: {maxHeight} :: Initial Velicity Count: {ivCount} :: Test Count: {testCount}"

# ------------------------------------------------------------------------------
if isMainModule:
    testProbeTrajectories()
