from dataclasses import dataclass
import dataclasses
from pathlib import Path

inputFileName = "input.txt"

@dataclass
class Message:
    typeId: int
    value: int
    version: int
    versionSum: int = 0
    messages = []

# -----------------------------------------------------------------------------
def readInput() -> str:
    cwd = Path(__file__).parent.absolute()

    with open(cwd / inputFileName) as f:
        return f.read().strip()

# -----------------------------------------------------------------------------
def parseLiteralValue(packets: str, startPos: int, message: Message):
    pos: int = startPos
    valueString: str = ""

    while True:
        more = packets[pos]
        pos += 1
        valueString += packets[pos:pos + 4]
        pos += 4

        if more == "0":
            break

    message.value = int(valueString, 2)

    return message, pos

# -----------------------------------------------------------------------------
def parseMessage(message: str, startPos: int):
    pos: int = startPos
    typeId: int = 0

    if startPos >= len(message):
        return None, pos

    version = int(message[pos: pos + 3], 2)
    pos += 3

    typeId = int(message[pos: pos + 3], 2)
    pos += 3

    if typeId == 4:
        msg = Message(typeId, 0, version)
        msg, pos = parseLiteralValue(message, pos, msg)
    else:
        msg, pos = parseOperatorMessage(message, pos, typeId)
        msg.version = version
        msg.typeId = typeId

    return msg, pos

# -----------------------------------------------------------------------------
def parseOperatorMessage(message: str, startPos: int, typeId: int):
    pos: int = startPos
    length: int

    msg = Message(typeId, 0, 0)
    msg.messages = []
    lengthTypeId = message[pos]
    pos += 1

    match lengthTypeId:
        case "0":

            # This means the length is represented by 15 bits, and the total length
            # of the rest of the message is the value of the length.
            length = int(message[pos: pos + 15], 2)
            pos += 15
            endPos = pos + length

            while pos < endPos - 6:
                # Read the sub packets
                subMsg, pos = parseMessage(message, pos)
                msg.versionSum += subMsg.version
                msg.messages.append(subMsg)

        case "1":
            # This means the length is represented by 11 bits, and the length represents
            # the number of sub-packets
            length = int(message[pos: pos + 11], 2)
            pos += 11

            for i in range(length):
                subMsg, pos = parseMessage(message, pos)
                msg.versionSum += subMsg.version
                msg.messages.append(subMsg)

        case _:
            print(f"    Invalid length type id {lengthTypeId}")

    match msg.typeId:
        case 0:     # Sum packets
            msg.value = sumValues(msg.messages)

        case 1:    # Multiply packets
            msg.value = 1

            for subMsg in msg.messages:
                msg.value *= subMsg.value

        case 2:    # Get minimum of packets
            msg.value = min(map(lambda x: x.value, msg.messages))

        case 3:    # Get maximum of packets
            msg.value = max(map(lambda x: x.value, msg.messages))

        case 5:    # Greater than packets
            msg.value = 1 if msg.messages[0].value > msg.messages[1].value else 0

        case 6:    # Less than packets
            msg.value = 1 if msg.messages[0].value < msg.messages[1].value else 0

        case 7:    # Equal to packets
            msg.value = 1 if msg.messages[0].value == msg.messages[1].value else 0

        case _:
            print(f"    Invalid message type id {msg.typeId}")

    return msg, pos

# -----------------------------------------------------------------------------
def parseMessages():
    position = 0
    messages: list[Message] = []

    packets = readInput()

    # Convert hex string to binary
    bin = "".join([f"{int(c, 16):04b}" for c in packets])

    # Parse the packets of the binary message packet
    while True:
        version = int(bin[position: position + 3], 2)
        position += 3

        typeId = int(bin[position: position + 3], 2)
        position += 3

        if typeId == 4:
            msg, position = parseLiteralValue(bin, 6)
            messages.append(msg)
        else:
            msg, position = parseOperatorMessage(bin, position, typeId)
            msg.typeId = typeId
            msg.version = version

        msg.version = version
        messages.append(msg)

        if position % 4 != 0:
            position += 4 - (position % 4)

        if position >= len(bin) - 6:
            break

    print(f"Value: {msg.value}")
   
# -----------------------------------------------------------------------------
def sumVersions(messages: list[Message]):
    versionSum = 0

    for msg in messages:
        versionSum += msg.version

        if len(msg.messages) > 0:
            versionSum += sumVersions(msg.messages)

    return versionSum

# -----------------------------------------------------------------------------
def sumValues(messages: list[Message]):
    sum = 0

    for msg in messages:
        sum += msg.value

        # if len(msg.messages) > 0:
        #     sum += sumValues(msg.messages)

    return sum

# -----------------------------------------------------------------------------
if __name__ == "__main__":
    parseMessages()
