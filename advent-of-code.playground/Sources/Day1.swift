import Foundation

public let dayOne = Day(name: "one") {
  guard let rawInput = contentsOfFile(name: "day-1", type: "txt") else {
    return
  }
  
  let input = rawInput.components(separatedBy: "\n").map { Int($0) }.compactMap { $0 }
  
  var prevSum: Int? = nil
  var isGreaterCount = 0
  
  input.forEach { num in
    if let prevSum = prevSum, num > prevSum {
      isGreaterCount += 1
    }
    
    prevSum = num
  }
  
  print("Individual: \(isGreaterCount)")
  
  var prevGroupedSum: Int? = nil
  var numInGroup = 3
  var groupedIsGreaterCount = 0
  input.enumerated().forEach { (index, num) in
    if index + numInGroup <= input.count {
      let group = Array(input[index..<index + numInGroup])
      let groupedSum = group.reduce(0, +)
      
      if let prevGroupedSum = prevGroupedSum, groupedSum > prevGroupedSum {
        groupedIsGreaterCount += 1
      }
      
      prevGroupedSum = groupedSum
    }
  }
  
  print("Grouped: \(groupedIsGreaterCount)")
}
