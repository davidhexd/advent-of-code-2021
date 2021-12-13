import Foundation

public let day8 = Day(name: "eight") {
  part1()
}

private func part1() {
  let lines = parseInput(fileName: "day-8-example-short")
  print(lines.map { $0.parse() })
}

private func makeWireToSegments() -> [String: Set<String>] {
  let wires = ["a", "b", "c", "d", "e", "f", "g"]
  return Dictionary(uniqueKeysWithValues: wires.map { ($0, Set(wires)) })
}

private func print(_ result: [String: Set<String>]) {
  result.sorted { a, b in
    return a.0 < b.0
  }.forEach { (key, value) in
    print("\(key): \(value.sorted())")
  }
}

private struct Line {
  let rawSignals: [String]
  let rawOutputs: [String]
  
  func parse() -> ([Int], [Int]) {
    let all = rawSignals + rawOutputs
    
    let finalWireToSegments = all.reduce(makeWireToSegments()) { currentWireToSegments, signal in
      let signalLength = signal.count
      guard let possibleNums = numSegmentsToNumMap[signalLength] else {
        fatalError("\(signal) is \(signalLength) which isn't valid")
      }
      
      var _currentWireToSegments = currentWireToSegments

      if let onlyNum = possibleNums.first, possibleNums.count == 1 {
        guard let segments = numToSegmentsMap[onlyNum] else {
          fatalError("Missing segments")
        }
                
        segments.forEach { character in
          guard let possibleSegments = _currentWireToSegments[String(character)] else {
            fatalError("missing possibleSegments")
          }
          
          _currentWireToSegments[String(character)] = possibleSegments.intersection(Set(signal.map { String($0) }))
        }
      }
      
      return _currentWireToSegments
    }
    
    print(finalWireToSegments)
    
    return ([], [])
  }
}

private func parseInput(fileName: String) -> [Line] {
  guard let contents = Helpers.contentsOfFile(name: fileName, type: "txt") else {
    fatalError()
  }
  
  return contents
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: "\n")
    .map { $0.trimmingCharacters(in: .whitespaces) }
    .map { $0.components(separatedBy: "|") }
    .map {
      $0.map { $0.trimmingCharacters(in: .whitespaces) }
    }.map { lineComponents -> Line in
      let rawSignals = lineComponents[0].components(separatedBy: " ")
      let rawOutputs = lineComponents[1].components(separatedBy: " ")
      return Line(rawSignals: rawSignals, rawOutputs: rawOutputs)
    }
}

private let numSegmentsToNumMap = [
  2: [1],
  3: [7],
  4: [4],
  5: [2, 3, 5],
  6: [0, 6, 9],
  7: [8]
]

// Maps length of unknown signal to possible segments
private let numToSegmentsMap = [
  0: ["a", "b", "c", "e", "f", "g"],
  1: ["c", "f"],
  2: ["a", "c", "d", "e", "g"],
  3: ["a", "c", "d", "f", "g"],
  4: ["b", "c", "d", "f"],
  5: ["a", "b", "d", "f", "g"],
  6: ["a", "b", "d", "e", "f", "g"],
  7: ["a", "c", "f"],
  8: ["a", "b", "c", "d", "e", "f", "g"],
  9: ["a", "b", "c", "d", "f", "g"],
]

