#[
    Define board data structure 5x5 array.
    Parse board data from board.txt file to array.

    Define function to go through boards to mark called numbers.

    Define function to check if board is solved.
]#

import
    strutils,
    std/strformat

const boardFileName = "boards.txt"
const numbersFileName = "input.txt"

# Board: 5x5 array

type
    BoardCell = ref object
        value: int
        isCalled: bool

type
    Board = array[0..4, array[0..4, BoardCell]]

var winners: seq[int] = @[]


# ...........................................................................
proc readBoards(): seq[Board] =
    let boardFile = open(boardFileName)
    defer: boardFile.close()

    var 
        boards: seq[Board] = @[]
        line: string

    while boardFile.readLine(line):
        while line.strip() == "":
            if not boardFile.readLine(line):
                break
        
        # Read 5 lines of board data
        var board: Board

        for row in 0..4:
            var data = line.splitWhitespace()
            for col in 0..4:
                board[row][col] = BoardCell(value: parseInt(data[col]), isCalled: false)
                
            if not boardFile.readLine(line):
                break

        boards.add(board)
    
    return boards

# ...........................................................................
proc callNumber(boards:seq[Board], calledNumber: int) =
    for i, board in boards:
        for row in 0..4:
            for col in 0..4:
                if board[row][col].value == calledNumber:
                    board[row][col].isCalled = true

# ...........................................................................
proc checkBoard(board: Board): bool =
    # Check rows
    var 
        rowGood = false
        colGood = false

    for row in 0..4:
        rowGood = false
        for col in 0..4:
            if board[row][col].isCalled:
                rowGood = true
            else:
                rowGood = false
                break

        if rowGood:
            echo &"Winner - Row {row + 1}"
            return true

    # Check columns
    for col in 0..4:
        colGood = false

        for row in 0..4:
            if board[row][col].isCalled:
                colGood = true
            else:
                colGood = false
                break

        if colGood:
            echo &"Winner - Col {col + 1}"
            return true

    return false

# ...........................................................................
proc checkBoards(boards: seq[Board]): int =
    var winner = -1

    for i, board in boards:
        if i in winners:
            # echo &"Skipping board {i} because it's already solved"
            continue

        var solved = checkBoard(board)

        if solved:
            winners.add(i)
            winner = i

    return winner

# ...........................................................................
proc printBoard(board: Board) =
    for row in 0..4:
        for col in 0..4:
            if board[row][col].isCalled:
                stdout.write(&"[{board[row][col].value:2}]")
            else:
                stdout.write(&" {board[row][col].value:2} ")
        
        stdout.write("\n")

# ...........................................................................
var boards: seq[Board] = readBoards()

let input = open(numbersFileName)
var inputContents = input.readAll()
input.close()
let numbers = inputContents.split(",")
var foundWinner = false

for number in numbers:
    echo &"--- Calling number {number} ---"
    let thisNumber = parseInt(number)
    boards.callNumber(thisNumber)
    var winner = boards.checkBoards

    if winner >= 0:
        foundWinner = true

        var winningBoard = boards[winner]
        printBoard(winningBoard)

        var sumUnmarked = 0
        var score = 0

        for row in 0..4:
            for col in 0..4:
                if not winningBoard[row][col].isCalled:
                    sumUnmarked += winningBoard[row][col].value

        score = sumUnmarked * thisNumber
        echo &"Board {winner} won! Score: {score} (Sum of unmarked: {sumUnmarked}, Last number called: {thisNumber})\n--------------\n"
