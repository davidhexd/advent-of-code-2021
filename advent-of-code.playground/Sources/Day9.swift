import Foundation

public let day9 = Day(name: "nine") {
  part1()
}

private func part1() {
  let map = parse(fileName: "day-9")
  let maxX = map[0].count
  let maxY = map.count
  
  let lowPoints = (0..<map[0].count).map { x in
    return (0..<map.count).map { y in
      return (x, y)
    }
  }
    .reduce([], +)
    .filter { (x, y) in
      let val = map[y][x]
      return neighbors((x, y), maxX: maxX, maxY: maxY).reduce(true) { isSmaller, neighbor in
        let neighborVal = map[neighbor.1][neighbor.0]
        return isSmaller && val < neighborVal
      }
    }
  
  let cost = lowPoints.reduce(0) { sum, point in
    return sum + map[point.1][point.0] + 1
  }

  print("Part 1: \(cost)")
}

func neighbors(_ point: (x: Int, y: Int), maxX: Int, maxY: Int) -> [(Int, Int)] {
  let (x, y) = point
  return [
    (x - 1, y),
    (x + 1, y),
    (x, y - 1),
    (x, y + 1)
  ].filter { (x, y) in
    if (x < 0 || y < 0) {
      return false
    } else if (x >= maxX) {
      return false
    } else if (y >= maxY) {
      return false
    } else {
      return true
    }
  }
}

private func parse(fileName: String) -> [[Int]] {
  guard let content = Helpers.contentsOfFile(name: fileName, type: "txt") else {
    fatalError()
  }
  
  return content
    .components(separatedBy: .whitespacesAndNewlines)
    .filter { !$0.isEmpty }
    .map { $0.map { Int(String($0)) }.compactMap { $0 }}
}
