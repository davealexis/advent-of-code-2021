import
    strutils,
    sequtils,
    strformat,
    sugar

type
    Rule = tuple
        pair: string
        insert: string

const inputFileName = "test-input.txt"

var
    polymer: string
    rules: seq[Rule] = @[]
    elements: set[char]

# -----------------------------------------------------------------------------
proc readInput() =
    let inputFile = open(inputFileName)
    defer: close(inputFile)

    polymer = inputFile.readLine.strip()
    discard inputFile.readLine

    var line: string
    
    while inputFile.readLine(line):
        let rule = line.split(" -> ")
        rules.add((rule[0], rule[1]))
        elements.incl(rule[0][0])
        elements.incl(rule[0][1])

# -----------------------------------------------------------------------------
proc buildPolymer(initialPolymer: string): string =
    var
        pairs: seq[string] = @[]
        polymerChain: seq[string] = @[]

    # Break initial polymer into pairs
    for i in 0 ..< initialPolymer.len - 1:
        pairs.add(initialPolymer[i..i+1])
    
    polymerChain.add($initialPolymer[0])

    # Process rules for each pair
    for pair in pairs:
        # echo pair
        let p = pair
        let rule: Rule = rules.filter(r => r.pair == p)[0]
        polymerChain.add(&"{rule.insert}{p[1]}")

    # echo polymerChain.join("")
    return polymerChain.join("")
    
# -----------------------------------------------------------------------------

if isMainModule:
    readInput()

    # Build polymer
    for steps in 1..10:
        polymer = buildPolymer(polymer)

    # Count elements in resulting polymer
    var
        maxCount: int = 0
        minCount: int = high(int)

    for element in elements:
        let count = polymer.count(element)
        echo &"{element}: {count}"
        
        if count > maxCount:
            maxCount = count
        
        if count < minCount:
            minCount = count
    
    echo &"Max: {maxCount}"
    echo &"Min: {minCount}"
    echo &"Result: {maxCount - minCount}"