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
    
# We need to test the fuel expenditure to get all crabs to each
# possible position, then select the one using the minimum fuel.
for p in minCrabPosition..maxCrabPosition:
    var distance: seq[int] = @[]

    # First we need to find the fuel used by each crab for each position
    for crab in crabs:
        distance.add(max(p, crab) - min(p, crab))
    
    var fuel:int = 0

    for d in distance:
        fuel += d

    fuelUsage.add(fuel)

echo &"Minimum fuel: {fuelUsage.min()}"
