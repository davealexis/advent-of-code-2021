import
    std/[sequtils, sugar],
    strutils

const inputFile = "input.txt"

proc findDigits() =
    let inputFile = open(inputFile)
    defer: inputFile.close()

    var line: string
    var digitCount = 0

    while inputFile.readline(line):
        let digitsPart = line.split(" | ")[1].split(" ")
        digitCount += digitsPart.filter(d => d.len == 2).len #in [2, 3, 4, 7]).len

    echo digitCount
    
findDigits()
