import
    std/strformat,
    strutils,
    sequtils,
    sugar

const inputFileName = "input.txt"
const days = 256

let fishies = readFile(inputFileName)
    .strip()
    .split(',')
    .map(i => parseInt(i))

var fishBuckets: array[0..9, int]

# Initialize the fish buckets
for f in fishies:
    fishBuckets[f] += 1

for day in 1..days:
    # echo &"Day {day}..."

    # Spawn a new generation of fishies for the batch at day 0
    if fishBuckets[0] > 0:
        fishBuckets[9] = fishBuckets[0]
        fishBuckets[7] += fishBuckets[0]
        fishBuckets[0] = 0
    
    # Decrement fish counters
    for f in 0..8:
        fishBuckets[f] = fishBuckets[f + 1]

    fishBuckets[9] = 0

var totalFish = 0

for f in fishBuckets:
    totalFish += f

echo &"Total fish: {totalFish}"