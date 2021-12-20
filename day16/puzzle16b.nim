import
    strutils,
    strformat,
    sequtils,
    sugar


const inputFileName = "input.txt"

type
    Message = object
        typeId: int
        value: int
        version: int
        versionSum: int
        messages: seq[Message]

proc parseOperatorMessage(message: string, startPos: int, typeId: int): (Message, int)

# -----------------------------------------------------------------------------
proc readInput(): string =
    let inputFile = open(inputFileName)
    defer: close(inputFile)

    return inputFile.readAll.strip

# -----------------------------------------------------------------------------
proc parseLiteralValue(packet: string, startPos: int, message: Message): (Message, int) =
    var
        pos: int = startPos
        valueString: string = ""
        msg = message

    while true:
        let more = packet[pos]
        pos += 1
        valueString &= packet[pos ..< pos + 4]
        pos += 4

        if $more == "0":
            break

    msg.value = fromBin[int](valueString)
    
    return (msg, pos)

# -----------------------------------------------------------------------------
proc parseMessage(message: string, startPos: int): (Message, int) =
    var
        pos: int = startPos
        typeId: int
        msg: Message

    if startPos >= len(message):
        return (msg, pos)

    let version = fromBin[int](message[pos .. pos + 2])
    pos += 3

    typeId = fromBin[int](message[pos .. pos + 2])
    pos += 3

    msg.typeId = typeId
    msg.version = version
    
    if typeId == 4:
        msg.typeId = typeId
        msg.version = version
        (msg, pos) = parseLiteralValue(message, pos, msg)
    else:
        (msg, pos) = parseOperatorMessage(message, pos, typeId)
        msg.version = version
        msg.typeId = typeId
    
    return (msg, pos)

# -----------------------------------------------------------------------------
proc parseOperatorMessage(message: string, startPos: int, typeId: int): (Message, int) =
    var
        pos: int = startPos
        length: int
        msg: Message
        subMsg: Message

    msg.typeId = typeId
    msg.value = 0
    msg.version = 0
    msg.messages = @[]

    let lengthTypeId = $message[pos]
    pos += 1

    case lengthTypeId
        of "0":
            
            # This means the length is represented by 15 bits, and the total length
            # of the rest of the message is the value of the length.
            length = fromBin[int](message[pos ..< pos + 15])
            pos += 15
            let endPos = pos + length - 6

            while pos < endPos:
                # Read the sub packets
                (subMsg, pos) = parseMessage(message, pos)
                msg.versionSum += subMsg.version
                msg.messages.add(subMsg)

        of "1":
            # This means the length is represented by 11 bits, and the length represents
            # the number of sub-packets
            length = fromBin[int](message[pos ..< pos + 11])
            pos += 11
            
            for i in 1 .. length:
                (subMsg, pos) = parseMessage(message, pos)
                msg.versionSum += subMsg.version
                msg.messages.add(subMsg)
        else:
            echo &"    Invalid length type id {lengthTypeId}"
    
    case msg.typeId
        of 0:     # Sum packets
            msg.value = msg.messages.map(m => m.value).foldl(a + b)

        of 1:    # Multiply packets
            msg.value = 1

            for subMsg in msg.messages:
                msg.value *= subMsg.value

        of 2:    # Get minimum of packets
            msg.value = msg.messages.map(m => m.value).foldl(if a < b: a else: b)

        of 3:    # Get maximum of packets
            msg.value = msg.messages.map(m => m.value).foldl(if a > b: a else: b)

        of 5:    # Greater than packets
            msg.value = if msg.messages[0].value > msg.messages[1].value: 1 else: 0

        of 6:    # Less than packets
            msg.value = if msg.messages[0].value < msg.messages[1].value: 1 else: 0

        of 7:    # Equal to packets
            msg.value = if msg.messages[0].value == msg.messages[1].value: 1 else: 0

        else:
            echo(&"Invalid message type id {msg.typeId}")

    return (msg, pos)

# -----------------------------------------------------------------------------
proc sumVersions(messages: seq[Message]): int =
    var versionSum = 0

    for msg in messages:
        versionSum += msg.version
        
        if len(msg.messages) > 0:
            versionSum += sumVersions(msg.messages)

    return versionSum

# -----------------------------------------------------------------------------
proc parseMessages() =
    var
        position: int = 0
        messages: seq[Message] = @[]
        msg: Message

    let packets = readInput()

    # Convert hex string to binary
    let bin = packets
        .map(c => $c)
        .map(c => fromHex[int]($c))
        .map(h => toBin(h, 4))
        .join("")

    # Parse the packets of the binary message packet
    while true:
        let version = fromBin[int](bin[position .. position + 2])
        position += 3

        let typeId = fromBin[int](bin[position .. position + 2])
        position += 3

        msg.version = version
        msg.typeId = typeId

        if typeId == 4:
            (msg, position) = parseLiteralValue(bin, position, msg)
            messages.add(msg)
        else:
            (msg, position) = parseOperatorMessage(bin, position, typeId)

        messages.add(msg)

        if position mod 4 != 0:
            position += 4 - (position mod 4)

        if position >= len(bin) - 6:
            break

    let versionSum = sumVersions(messages)
    echo &"Version Sum: {versionSum}"
    echo &"Value: {msg.value}"

# -----------------------------------------------------------------------------

when isMainModule:
    parseMessages()
