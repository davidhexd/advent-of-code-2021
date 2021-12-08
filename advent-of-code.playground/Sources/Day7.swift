import Foundation

public let day7 = Day(name: "seven") {
  part1()
}

private func part1() {
  let crabPositions = parseInput(fileName: "day-7")
  let sorted = crabPositions.sorted()
    
  // Do binary search?
  let min = sorted.first!
  let max = sorted.last!

  let bruteForce = (min...max).map { position -> (Int, Int) in
    let travelDistance = crabPositions.reduce(0) { totalDistance, currentCrabPosition in
      return totalDistance + (abs(currentCrabPosition - position))
    }

    return (position, travelDistance)
  }.sorted { a, b in
    return a.1 < b.1
  }
  
  print("Part 1: \(bruteForce.first)")
}

private func parseInput(fileName: String) -> [Int] {
  guard let contents = Helpers.contentsOfFile(name: fileName, type: "txt") else {
    fatalError()
  }
  
  return contents
    .components(separatedBy: .whitespacesAndNewlines)
    .flatMap {
      $0.components( separatedBy:",")
    }
    .map { Int($0) }
    .compactMap { $0 }
}
