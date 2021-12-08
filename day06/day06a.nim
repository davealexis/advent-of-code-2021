#[
    Given a set of Lanternfish in the input.txt file, model how many fish there would be after 80 days.
    Each fish has an internal timer that counts down. When the timer reaches 0, the fish spawns a new fish
    the next day (i.e. when the timer reaches -1). The timer is then reset to 6.
    Newly spawned fish get an initial timer of 8.

    !!!! This turned out to be a terrible solution. See the part B code for a much better solution.
]#

import
    strformat,
    strutils,
    sequtils,
    sugar

const 
    FishFileName = "test-input.txt"
    MaxFishBatchSize = 2_000_000

# .............................................................................
proc readFishData(fileName: string): seq[int] =
    let fishData = readFile(fileName).strip()

    # echo &"Read fish {fishData}"
    let fishies = toSeq(fishData.split(",")).map(f => parseInt(f))

    return fishies

# .............................................................................
proc saveFishBatch(fishies: seq[int], fileName: string) =
    let fishiesStr = join(fishies, ",")
    writeFile(fileName, fishiesStr)
    # echo &"Saved {len(fishies)} fishies to {fileName}."

# .............................................................................
proc modelFishBatch(batchName: string, daysToModel: int): seq[int] =
    var fishies: seq[int] = readFishData(batchName)
    # echo &"Modelling batch of fish - {batchName} with {len(fishies)} fishies."

    for day in 1..daysToModel:
        var newFish: seq[int] = @[]

        for fish, counter in fishies:
            if counter == 0:
                newFish.add(8)
            
            fishies[fish] = if counter == 0: 6 else: counter - 1
        
        if len(newFish) > 0:
            fishies.add(newFish)
        
        # echo &"Day {day}: {fishies}"


        # echo &"Batch {batchName}, Day {day}: {len(fishies)}"

    return fishies

# .............................................................................
proc modelFishies(initialFish: seq[int], daysToModel: int): int =
    var 
        fishies: seq[int] = initialFish
        fishBatches: seq[string] = @[]
        day = 1
        newFishBatches: seq[string] = @[]
        batches = 1

    # Give the initial batch of fish a cache file name
    let initialFishFile = &"fishies_{batches}.txt"
    fishBatches.add(initialFishFile)
    saveFishBatch(fishies, initialFishFile)

    while day <= daysToModel:
        stdout.write(&"\rDay {day}. Processing {len(fishBatches)} batches.                                                    ")

        for fishBatch in fishBatches:
            stdout.write(&" \r   Processing batch {fishBatch:}.    ")

            var fishies = modelFishBatch(fishBatch, 1)
            
            if len(fishies) > MaxFishBatchSize:
                saveFishBatch(fishies[0..500_000], fishBatch)
                batches += 1
                var newFishFile = &"fishies_{batches}.txt"
                newFishBatches.add(newFishFile)
                saveFishBatch(fishies[500_001..1_000_000], newFishFile)
                batches += 1
                newFishFile = &"fishies_{batches}.txt"
                newFishBatches.add(newFishFile)
                saveFishBatch(fishies[1_000_001..1_500_000], newFishFile)
                batches += 1
                newFishFile = &"fishies_{batches}.txt"
                newFishBatches.add(newFishFile)
                saveFishBatch(fishies[1_500_001..^1], newFishFile)
                stdout.write(&" \rDay {day}. Processing batch {fishBatch:}. Split fishies into {batches} batches\r")
            else:
                # echo fishies
                saveFishBatch(fishies, fishBatch)
            
        if len(newFishBatches) > 0:
            fishBatches.add(newFishBatches)
            newFishBatches = @[]

        day = day + 1

    # Return total number of fish
    var totalFish = 0
    
    for fishBatch in fishBatches:
        let b = len(readFishData(fishBatch))
        # echo &"Batch {fishBatch}: {b}"
        totalFish += b

    return totalFish

# .............................................................................
when isMainModule:
    var fishies = readFishData(FishFileName)
    var totalFish = modelFishies(fishies, 80)

    echo &"Total fishies: {totalFish}"
