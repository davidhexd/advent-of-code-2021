import Foundation
import CoreGraphics

public let day5 = Day(name: "five") {
  part1()
  part2()
}

struct Point: CustomStringConvertible {
  let x: Int
  let y: Int
  
  var description: String {
    return "\(x),\(y)"
  }
}

struct Line: CustomStringConvertible {
  let start: Point
  let end: Point
  
  func points(supportsDiagonals: Bool) -> [Point] {
    if start.x == end.x {
      let lowerValue = min(start.y, end.y)
      let higherValue = max(start.y, end.y)
      return (lowerValue...higherValue).map { Point(x: start.x, y: $0) }
    } else if start.y == end.y {
      let lowerValue = min(start.x, end.x)
      let higherValue = max(start.x, end.x)
      return (lowerValue...higherValue).map { Point(x: $0, y: start.y) }
    } else {
      guard supportsDiagonals else {
        return []
      }
      guard abs(start.x - end.x) == abs(start.y - end.y) else {
        return []
      }
      
      let distance = abs(start.x - end.x)
      
      let shouldIncreaseX = start.x < end.x
      let shouldIncreaseY = start.y < end.y
      
      let points = (0...distance).map { interval in
        return Point(
          x: shouldIncreaseX ? (start.x + interval) : (start.x - interval),
          y: shouldIncreaseY ? (start.y + interval) : (start.y - interval))
      }

      return points
    }
  }
  
  var description: String {
    return "\(start)->\(end)"
  }
}

struct Map: CustomStringConvertible {
  
  init(_ lines: [Line], supportsDiagonals: Bool) {
    // Find max x, y
    struct Max {
      let x: Int
      let y: Int
    }
    
    let linesMax = lines.reduce(Max(x: 0, y: 0)) { currentMax, line in
      return Max(
        x: max(currentMax.x, line.start.x, line.end.x),
        y: max(currentMax.y, line.start.y, line.end.y))
    }
    
    let points: [[Int]] = (0...linesMax.y+1).map { _ in
      Array(repeating: 0, count: linesMax.x+1)
    }
    
    self.points = lines.reduce(points) { points, line in
      // Apply line to points
      let pointsInLine = line.points(supportsDiagonals: supportsDiagonals)
      var newPoints = points
      pointsInLine.forEach { point in
        let curValue = newPoints[point.y][point.x]
        newPoints[point.y][point.x] = curValue + 1
      }
      
      return newPoints
    }
  }
  
  let points: [[Int]]
 
  var description: String {
    points.map { row in
      row.map { value in
        if value == 0 {
          return "."
        } else {
          return "\(value)"
        }
      }.joined(separator: "")
    }.joined(separator: "\n")
  }
}


func part1() {
  let lines = parseInput(fileName: "day-5")
  let map = Map(lines, supportsDiagonals: false)
  let maxCount = map.points.flatMap { $0 }.filter { $0 >= 2 }.count
  print("Part 1: \(maxCount)")
}

func part2() {
  let lines = parseInput(fileName: "day-5")
  let map = Map(lines, supportsDiagonals: true)
  let maxCount = map.points.flatMap { $0 }.filter { $0 >= 2 }.count
  print("Part 2: \(maxCount)")
}

func parseInput(fileName: String) -> [Line] {
  guard let input = Helpers.contentsOfFile(name: fileName, type: "txt") else {
    fatalError()
  }
  
  return input
    .components(separatedBy: "\n")
    .filter { !$0.isEmpty }
    .map { nonEmptyLine in
      return nonEmptyLine
        .components(separatedBy: "->")
        .filter { !$0.isEmpty }
        .map { lineComponents in
          return lineComponents
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ",")
        }.map { pointComponents in
          return pointComponents.map { Int($0)! }
        }.map { pointComponents -> Point? in
          guard pointComponents.count == 2 else {
            return nil
          }
          
          return Point(x: pointComponents[0], y: pointComponents[1])
        }.compactMap { $0 }
    }.map { points -> Line? in
      guard points.count == 2 else {
        return nil
      }
      
      return Line(start: points[0], end: points[1])
    }.compactMap { $0 }
}


