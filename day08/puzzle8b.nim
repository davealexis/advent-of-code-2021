
#[
    acedgfb: 8
    cdfbe: 5
    gcdfa: 2
    fbcad: 3
    dab: 7
    cefabd: 9
    cdfgeb: 6
    eafb: 4
    cagedb: 0
    ab: 1
]#

import
    std/tables,
    std/sequtils,
    strutils,
    sugar,
    algorithm


const inputFile = "test-input.txt"

var
    digits = initTable[string, int]()


proc findDigits() =
    let inputFile = open(inputFile)
    defer: inputFile.close()

    var line: string
    var digitCount = 0

    while inputFile.readline(line):
        let digitsPart = line.split(" | ")[1].split(" ")

        for digit in digitsPart:
            case digit.len
                of 2:
                    digits[toSeq(digit.items).sorted(cmp).join()] = 1
                
                of 3:
                    digits[toSeq(digit.items).sorted(cmp).join()] = 7
                
                of 4:
                    digits[toSeq(digit.items).sorted(cmp).join()] = 4
                
                of 7:
                    digits[toSeq(digit.items).sorted(cmp).join()] = 8
                
                else:
                    digits[toSeq(digit.items).sorted(cmp).join()] = 0
        
        echo digits


proc processData() =
    let inputFile = open(inputFile)
    defer: inputFile.close()

    var line: string
    var digitCount = 0

    var numbers = initTable[string, int]()
    numbers[toSeq("cagedb".items).sorted(cmp).join()] = 0
    numbers[toSeq("ab".items).sorted(cmp).join()] = 1
    numbers[toSeq("gcdfa".items).sorted(cmp).join()] = 2
    numbers[toSeq("cedba".items).sorted(cmp).join()] = 3
    numbers[toSeq("gcbe".items).sorted(cmp).join()] = 4
    numbers[toSeq("dcbef".items).sorted(cmp).join()] = 5
    numbers[toSeq("cdfgeb".items).sorted(cmp).join()] = 6
    numbers[toSeq("dab".items).sorted(cmp).join()] = 7
    numbers[toSeq("acedgfb".items).sorted(cmp).join()] = 8
    numbers[toSeq("cefbgd".items).sorted(cmp).join()] = 9

    echo numbers

    while inputFile.readline(line):
        let digits = line.split(" | ")[1].split(" ")
        echo digits
        var thisNUmber = 0

        for digit in digits:
            let d = toSeq(digit.items).sorted(cmp).join()
            echo d
            thisNUmber = thisNUmber * 10 + numbers[d]
            echo thisNumber

        echo thisNUmber

    echo digitCount

# .............................................................................
findDigits()
