import 
    std/strformat, 
    strutils, 
    sequtils

const BitCount = 12

# ...........................................................................
proc calcPower() =
    let f = open("./input.txt")
    defer: f.close()

    var
        rcount: int
        bitsums:  array[BitCount, int]
        line: string
        gamma: int
        epsilon: int

    while f.readLine(line):
        let bits = toSeq(line.items())

        for i in 0..BitCount-1:
            bitsums[i] += parseInt($bits[i])
        
        rcount += 1

    let half = int(rcount / 2)

    for i in 0..BitCount-1:
        gamma = (gamma shl 1) + (if bitsums[i] >= half: 1 else: 0)
        epsilon = (epsilon shl 1) + (if bitsums[i] < half: 1 else: 0)

    let power = gamma * epsilon

    echo &"Gamma: {gamma}. Epsilon: {epsilon}. Power: {power}"

# ...........................................................................
calcPower()