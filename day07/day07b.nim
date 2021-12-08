import
    std/strformat,
    strutils,
    sequtils,
    sugar

const inputFileName = "input.txt"

let crabs = readFile(inputFileName)
    .strip()
    .split(',')
    .map(i => parseInt(i))

var
    minCrabPosition = crabs.min()
    maxCrabPosition = crabs.max()
    fuelUsage: seq[int]
    

for p in minCrabPosition..maxCrabPosition:
    var fuelTest: seq[int] = @[]

    # First we need to find the fuel used by each crab for each position
    for crab in crabs:
        let distance = float(max(p, crab) - min(p, crab))

        # Once we know the distance a crab needs to travel to a given position,
        # we can calculate the fuel required to get there using the formula
        # for calculating the sum of sonsecutive digits between two numbers.
        let fuel = int((distance / 2.0) * (1.0 + distance))
        fuelTest.add(fuel)
    
    var fuel:int = 0

    # Now we can determine the total fuel needed for all crabs to get to the current position
    for f in fuelTest:
        fuel += f

    fuelUsage.add(fuel)

echo &"Minimum fuel: {fuelUsage.min()}"
