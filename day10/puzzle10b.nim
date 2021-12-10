import
    strutils,
    strformat,
    tables,
    algorithm

const inputFileName = "input.txt"

let
    openers = {
        '(': ')', 
        '[': ']', 
        '{': '}', 
        '<': '>'
    }.toTable()   
    closers = { 
        ')': 1, 
        ']': 2, 
        '}': 3, 
        '>': 4
    }.toTable()

# ------------------------------------------------------------------------------
proc parseNavigationData() =
    echo "Parsing navigation data..."

    var scores: seq[int] = @[]

    for line in inputFileName.lines:
        var 
            data: seq[char] = @[]
            isCorruptLine: bool = false

        for ci in 0..<line.len:
            let c = line[ci]

            if c in openers:
                data.add(c)
            else:
                if c notin closers:
                    echo &"Unexpected character '{c} in line [{line}]"
                    break
                
                # Check if the last item on the stack is the expected opener charater
                let 
                    opener = data.pop()
                    expectedCloser = openers[opener]

                if c != expectedCloser:
                    # echo &"Expected '{expectedCloser}' but found '{c} in line {line}'"
                    # score += closers[c]
                    isCorruptLine = if ci < line.len - 1: true else: false
                    break
                    
                # discard data.pop()

        if data.len > 0 and isCorruptLine == false:
            # Complete the line and determine the score for the completion
            # echo &"Line: {line} is incomplete"
            
            var lineScore = 0

            while data.len > 0:
                let 
                    d = data.pop()
                    closer = openers[d]

                # stdout.write(closer)
                lineScore = lineScore * 5 + closers[closer]

            # stdout.write("\n")
            scores.add(lineScore)
            # echo &"Line Score: {lineScore}"

    # echo &"Score: {scores.sorted(cmp)}"
    echo &"Score: {scores.sorted(cmp)[int(scores.len / 2)]}"

if isMainModule:
    parseNavigationData()
