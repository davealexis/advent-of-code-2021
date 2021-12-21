import
    strformat,
    strutils,
    os,
    terminal

type
    TargetArea = object
        x1: int
        x2: int
        y1: int
        y2: int

    Velocity = tuple
        x: int
        y: int

# -----------------------------------------------------------------------------
proc buildTargetField(inputFileName: string): TargetArea =
    let input = readFile(inputFileName)
            .strip()
            .split(": ")[1]
            .split(", ")
        
    let x = input[0].split("=")[1].split("..")
    let y = input[1].split("=")[1].split("..")

    return TargetArea(
        x1: parseInt(x[0]),
        x2: parseInt(x[1]),
        y1: parseInt(y[0]),
        y2: parseInt(y[1])
    )

# -----------------------------------------------------------------------------
proc fireProbe(velocity: Velocity, target: TargetArea): (bool, int) =
    var
        v = velocity
        x: int = 0
        y: int = 0
        step: int = 0
        highestPoint: int = 0

    # Test values for y until we miss or hit the target
    while true:

        # Calculate the next position
        step += 1
        x += v.x
        y += v.y

        highestPoint = max(highestPoint, y)

        # Check if we're in the target area
        if target.x1 <= x and x <= target.x2 and target.y1 <= y and y <= target.y2:
            return (true, highestPoint)

        if y < target.y1:
            # echo "\nMissed! Went through"
            return (false,  0)

        # Update velocity
        if v.x > 0:
            v.x -= 1
        elif v.x < 0: 
            v.x += 1
        
        v.y -= 1

# -----------------------------------------------------------------------------
if isMainModule:
    let inputFileName = paramStr(1)

    # The initial x,y velocity is read from the command line parameters
    let target = buildTargetField(inputFileName)
    
    var 
        hit: bool
        highPoint: int
        highestPoint: int = 0
        usableVelocities: int = 0

    try:    
        stdout.hidecursor()

        # Run the simulation to see if the target is hit
        for vX in 0..1000:
            for vY in -500..1000:
                (hit, highPoint) = fireProbe((vX, vY), target)

                if hit:
                    usableVelocities += 1
                    highestPoint = max(highestPoint, highPoint)
                    stdout.write &"\rHigh Point: {highPoint:-8} with vX: {vX:-8} vY: {vY:-8}. Higheset Point: {highestPoint:-8} with {usableVelocities:-6} usable velocities"

        terminal.eraseline()
        echo &"Highest Point: {highestPoint}"
        echo &"Usable Velocities: {usableVelocities}"
    finally:
        stdout.showcursor()