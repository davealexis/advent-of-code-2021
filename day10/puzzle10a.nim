import
    strutils,
    strformat,
    tables

const inputFileName = "test-input.txt"

let
    openers = {
        '(': ')', 
        '[': ']', 
        '{': '}', 
        '<': '>'
    }.toTable()   
    closers = { 
        ')': 3, 
        ']': 57, 
        '}': 1197, 
        '>': 25137
    }.toTable()

# ------------------------------------------------------------------------------
proc parseNavigationData() =
    echo "Parsing navigation data..."

    var
        data: seq[char] = @[]
        score: int = 0

    for line in inputFileName.lines:
        for c in line:
            if c in openers:
                data.add(c)
            else:
                if c notin closers:
                    echo &"Unexpected character '{c} in line [{line}]"
                    break
                
                # Check if the last item on the stack is the expected opener charater
                let 
                    opener = data[^1]
                    expectedCloser = openers[opener]

                if c != expectedCloser:
                    echo &"Expected '{expectedCloser}' but found '{c} in line {line}'"
                    score += closers[c]
                    break

                discard data.pop()

    echo &"Score: {score}"

if isMainModule:
    parseNavigationData()
