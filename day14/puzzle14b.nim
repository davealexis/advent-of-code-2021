import
    strutils,
    strformat,
    tables

const inputFileName = "input.txt"

var
    rules: Table[string, string]
    counts: Table[string, int]

# -----------------------------------------------------------------------------
proc readInput(): (Table[string, int], Table[string, string], Table[string, int]) =
    let inputFile = open(inputFileName)
    defer: close(inputFile)

    var
        polymerChain: Table[string, int]
        polymer: string
        rules: Table[string, string]
        counts: Table[string, int]

    polymer = inputFile.readLine.strip()

    for c in polymer:
        if $c notin counts:
            counts[$c] = 0

        counts[$c] += 1

    discard inputFile.readLine

    var line: string
    
    while inputFile.readLine(line):
        let rule = line.split(" -> ")
        rules[rule[0]] = rule[1]
        polymerChain[rule[0]] = 0

    # Break initial polymer into pairs
    for i in 0 ..< polymer.len - 1:
        polymerChain[polymer[i..i+1]] += 1

    return (polymerChain, rules, counts)

# -----------------------------------------------------------------------------
proc buildPolymer(pairs: Table[string, int]): Table[string, int] =
    for pair in pairs.keys():
        if pairs[pair] == 0: 
            continue
        
        # Generate new polymer pair
        # decrement counter from old polymer pair
        # Increment counter from new polymer pair
        let 
            pKey = pair
            insert = rules[pKey]
            newPair = &"{pair[0]}{insert}"
            newPair2 = &"{insert}{pair[1]}"
            oldCount = pairs[pKey]

        if newPair notin result:
            result[newPair] = 0
        
        result[newPair] += oldCount

        if newPair2 notin result:
            result[newPair2] = 0
        
        result[newPair2] += oldCount
    
        if insert notin counts:
            counts[insert] = 0

        counts[insert] += oldCount

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

if isMainModule:
    var polymerChain: Table[string, int]

    (polymerChain, rules, counts) = readInput()

    # Build polymer
    for step in 1 .. 40:
        echo &"Step {step}..."
        polymerChain = buildPolymer(polymerChain)

    # Count elements in resulting polymer
    var
        maxCount: int = 0
        minCount: int = high(int)

    for count in counts.values():
        if count > maxCount:
            maxCount = count
        
        if count < minCount:
            minCount = count
    
    echo &"Max: {maxCount}"
    echo &"Min: {minCount}"
    echo &"Result: {maxCount - minCount}"