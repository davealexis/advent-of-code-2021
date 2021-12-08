import
    std/strformat,
    strutils,
    sequtils,
    sugar

const BitCount = 12

# .................................................................................................
proc calcLifeSupport() =
    let f = open("input.txt")
    defer: f.close()

    var
        oxygen: seq[string]
        co2: seq[string]
        lineCount = 0
        oneBits = 0
        line: string

    while f.readLine(line):
        oxygen.add(line)
        co2.add(line)

        lineCount += 1
        oneBits += (if line[0] == '1': 1 else: 0)
    
    let mostCommon = if oneBits > int(lineCount / 2): '1' else: '0'
    var bitPos = 0

    while bitPos < BitCount:
        # Find most common bit in this position in the oxygen sequence
        oneBits = oxygen.map(x => x[bitPos]).filter(x => x == '1').len()
        let zeroBits = oxygen.len() - oneBits
        let mostCommon = if oneBits >= zeroBits: '1' else: '0'
        oxygen = oxygen.filter(x => x[bitPos] == mostCommon)

        if oxygen.len() == 1:
            break

        bitPos += 1

    bitPos = 0

    while bitPos < BitCount:
        # Find most common bit in this position in the oxygen sequence
        oneBits = co2.map(x => x[bitPos]).filter(x => x == '1').len()
        let zeroBits = co2.len() - oneBits
        let leastCommon = if oneBits < zeroBits: '1' else: '0'
        co2 = co2.filter(x => x[bitPos] == leastCommon)

        if co2.len() == 1:
            break

        bitPos += 1

    let oBits = oxygen[0]
    let co2Bits = co2[0]
    var
        oNumber = 0
        co2Number = 0

    for i in 0 .. BitCount - 1:
        oNumber = (oNumber shl 1) + parseInt($oBits[i])
        co2Number = (co2Number shl 1) + parseInt($co2Bits[i])

    echo &"Oxygen: {oNumber}, co2: {co2Number} Life support: {oNumber * co2Number}"


# .................................................................................................
calcLifeSupport()