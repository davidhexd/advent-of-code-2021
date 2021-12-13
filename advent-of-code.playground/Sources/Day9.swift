import Foundation

public let day9 = Day(name: "nine") {
  part1()
  part2()
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
    .map { Point($0.0, $0.1) }
    .filter { point in
      let val = map[point.y][point.x]
      return neighbors(point, maxX: maxX, maxY: maxY).reduce(true) { isSmaller, neighbor in
        let neighborVal = map[neighbor.y][neighbor.x]
        return isSmaller && val < neighborVal
      }
    }
  
  let cost = lowPoints.reduce(0) { sum, point in
    return sum + map[point.y][point.x] + 1
  }
  
  print("Part 1: \(cost)")
}

private struct Point: Hashable, CustomStringConvertible {
  let x: Int
  let y: Int
  
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
  
  var description: String {
    return "\(x),\(y)"
  }
}

private func part2() {
  let map = parse(fileName: "day-9")
//  print(map)
  let maxX = map[0].count
  let maxY = map.count
  
  let points = (0..<map.count).map { y in
    return (0..<map[0].count).map { x in
      return (x, y)
    }
  }.reduce([], +).map { point in
    return Point(point.0, point.1)
  }
  
//  print(points)
  
  var pointsToBasins: [Point: String] = [:]
  var basinCount = 0
  
  let lowPoints = (0..<map[0].count).map { x in
    return (0..<map.count).map { y in
      return (x, y)
    }
  }
    .reduce([], +)
    .map { Point($0.0, $0.1) }
    .filter { point in
      let val = map[point.y][point.x]
      return neighbors(point, maxX: maxX, maxY: maxY).reduce(true) { isSmaller, neighbor in
        let neighborVal = map[neighbor.y][neighbor.x]
        return isSmaller && val < neighborVal
      }
    }
  
  var basinsToPoints: [String: [Point]] = [:]
  lowPoints.forEach { point in
    pointsToBasins[point] = "\(basinCount)"
    basinsToPoints["\(basinCount)"] = [point]
    basinCount += 1
  }
  
  var pointsToVisit = lowPoints
  
  while (pointsToVisit.count > 0) {
    let point = pointsToVisit.first!
    let basin = pointsToBasins[point]!
    
    let _n = neighbors(point, maxX: maxX, maxY: maxY)
      .filter { map[$0.y][$0.x] != 9 && pointsToBasins[$0] == nil }
    
//    print("\(point) has \(_n) neighbors. \(pointsToVisit.count)")
    _n.forEach {
      pointsToBasins[$0] = basin
      
//      print(basinCount)
      var _u = basinsToPoints["\(basin)"]!
      _u.append(point)
      basinsToPoints["\(basin)"] = _u
    }
    
    pointsToVisit = Array(pointsToVisit.dropFirst())
    pointsToVisit.append(contentsOf: _n)
  }

//  (0..<map.count).forEach { y in
//    let line =  (0..<map[0].count).map { x in
//      let point = Point(x, y)
//
//      return pointsToBasins[point] ?? "X"
//    }.joined(separator: " ")
//
//    print(line)
//  }
  
  let total = Array(basinsToPoints.values
                        .map { $0.count }
                        .sorted()
                        .reversed()
                        .prefix(3)).reduce(1, *)
  
  print("Part 2: \(total)")
}

private func neighbors(_ point: Point, maxX: Int, maxY: Int) -> [Point] {
  return [
    Point(point.x - 1, point.y),
    Point(point.x + 1, point.y),
    Point(point.x, point.y - 1),
    Point(point.x, point.y + 1)
  ].filter { _point in
    if (_point.x < 0 || _point.y < 0) {
      return false
    } else if (_point.x >= maxX) {
      return false
    } else if (_point.y >= maxY) {
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
