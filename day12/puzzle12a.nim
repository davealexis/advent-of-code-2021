#[
    The paths represent cyclical paths in the graph.

    Goal:
        Find all paths from start to end.
]#

import
    strutils,
    sequtils,
    strformat,
    sugar,
    sets,
    deques

const inputFileName = "input.txt"

type
    Edge = tuple
        s: string
        e: string

type
    QEntry = tuple
        name: string
        visited: HashSet[string]

# ------------------------------------------------------------------------------
proc readGraph(): seq[Edge] =
    var
        graph: seq[Edge] = @[]

    for entry in inputFileName.lines:
        var vertices = entry.split("-")

        graph.add((vertices[0], vertices[1]))
        graph.add((vertices[1], vertices[0]))

    return graph

# ------------------------------------------------------------------------------
proc findPaths(graph: seq[Edge]): int =
    var
        queue: Deque[QEntry]
        startNode: QEntry = ("start",  toHashSet(["start"]))
        pathCount = 0

    queue = [startNode].toDeque()

    while queue.len > 0:
        var
            node = queue.popFirst()

        if node.name == "end":
            pathCount += 1
            continue

        for edge in graph.filter(n => n.s == node.name):
            if edge.e notin node.visited:
                var newNode: QEntry
                newNode.name = edge.e
                newNode.visited.incl(node.visited)

                if edge.e == edge.e.toLower():
                    newNode.visited.incl(edge.e)

                queue.addLast(newNode)

    return pathCount

# ------------------------------------------------------------------------------
if isMainModule:
    let 
        graph = readGraph()
        paths = findPaths(graph)
    
    echo &"Paths: {paths}"
