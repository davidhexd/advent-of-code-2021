import Foundation

public let day3 = Day(name: "three") {
  guard let rawContents = Helpers.contentsOfFile(name: "day-3", type: "txt") else {
    return
  }
  
  let lines = rawContents
    .components(separatedBy: "\n")
    .map { line -> String? in
      return line.count > 0 ? line : nil
    }.compactMap { $0 }
  
  guard let length = lines.first?.count else {
    return
  }
  
  // Part 1
  let finalState = lines.reduce(StatePart1(length: length), { partialResult, line in
    return partialResult.applying(line)
  })
  
  print("Part 1: \(finalState.gamma().binaryAsInt() * finalState.epsilon().binaryAsInt())")
  
  // Part 2
  print("Part 2: \(finalState.oxygenGeneratorRating().binaryAsInt() * finalState.co2ScrubberRating().binaryAsInt())")
}

struct StatePart1 {
  init(length: Int) {
    let counts = (0..<length).map { _ in CountPerBit(oneCount: 0, total: 0) }
    self.init(counts: counts, lines: [])
  }
  
  init(counts: [CountPerBit], lines: [String]) {
    self.counts = counts
    self.lines = lines
  }
  
  struct CountPerBit {
    let oneCount: Int
    let total: Int
    
    func increment(isOne: Bool) -> CountPerBit {
      let newTotal = total + 1
      var newOneCount = oneCount
      if (isOne) {
        newOneCount += 1
      }
      
      return CountPerBit(oneCount: newOneCount, total: newTotal)
    }
  }
  
  let counts: [CountPerBit]
  let lines: [String]
  
  func applying(_ line: String) -> StatePart1 {
    guard line.count == counts.count else {
      fatalError("Attempted to parse \(line) which has \(line.count) for State that expects \(counts.count)")
    }
    
    let newCounts = zip(counts, line).map { (countPerBit, character) in
      return countPerBit.increment(isOne: character == "1")
    }
    
    var lines = lines
    lines.append(line)
    return StatePart1(counts: newCounts, lines: lines)
  }
  
  func gamma() -> String {
    counts.map { count -> String in
      let oneCount = count.oneCount
      let zeroCount = count.total - oneCount
      if oneCount > zeroCount {
        return "1"
      } else {
        return "0"
      }
    }.joined(separator: "")
  }
  
  func epsilon() -> String {
    counts.map { count -> String in
      let oneCount = count.oneCount
      let zeroCount = count.total - oneCount
      if oneCount > zeroCount {
        return "0"
      } else {
        return "1"
      }
    }.joined(separator: "")
  }
  
  func oxygenGeneratorRating() -> String {
    return part2Rating(.most)
  }
  
  func co2ScrubberRating() -> String {
    return part2Rating(.least)
  }
  
  enum FilterType {
    case most
    case least
  }
  
  func part2Rating(_ filterType: FilterType) -> String {
    let finalLines = counts.enumerated().reduce(lines) { currentLines, x in
      if currentLines.count == 1 {
        return currentLines
      }
      
      let (index, _) = x
      
      // Compute new state based on currentLines
      let newState = currentLines.reduce(StatePart1(length: counts.count)) { partialResult, line in
        return partialResult.applying(line)
      }
      
      let newStateCurrentCount = newState.counts[index]
      let oneCount = newStateCurrentCount.oneCount
      let zeroCount = newStateCurrentCount.total - newStateCurrentCount.oneCount
      
      let filterChar: String = {
        switch filterType {
        case .most:
          return oneCount >= zeroCount ? "1" : "0"
        case .least:
          return oneCount >= zeroCount ? "0" : "1"
        }
      }()
      
      let filtered = currentLines.filter { line in
        let characterAtIndex = line[String.Index(utf16Offset: index, in: line)]
        return String(characterAtIndex) == filterChar
      }
      
      return filtered
    }
    
    return finalLines[0]
  }
}



extension String {
  
  func binaryAsInt() -> Int {
    return Int(self, radix: 2)!
  }
  
}
