import Foundation

public let day6 = Day(name: "six") {
  part1()
  part2()
}

private func part1() {
//  print("Part 1: \(modelFish_slow(fileName: "day-6", after: 80))")
}
private func part2() {
  print("Part 2")
  let initialFish = parseInput(fileName: "day-6-example")
  print((1...7).map { "\($0):\(modelFish_fast(initialFish: [$0], after: 18))"}.joined(separator: "\n"))
  
  let s_1 = Date()
  print("fast: \(modelFish_fast(initialFish: initialFish, after: 18))")
  print(Date().timeIntervalSince1970 - s_1.timeIntervalSince1970)
  let s_0 = Date()
  print("slow: \(modelFish_slow(initialFish: initialFish, after: 18))")
  print(Date().timeIntervalSince1970 - s_0.timeIntervalSince1970)
}


private func modelFish_slow(initialFish: [Int], after days: Int) -> Int {
  let finalFish = (1...days).reduce(initialFish) { currentFish, day in
    var fishToAdd: [Int] = []
    
    var newFish = currentFish
      .map { fish -> Int in
        if (fish == 0) {
          fishToAdd.append(8)
          return 6
        } else {
          let newFish = max(0, fish - 1)
          return newFish
        }
      }
    
    newFish.append(contentsOf: fishToAdd)
    print("\(day): \(newFish)")
    return newFish
  }
  return finalFish.count
}

private func modelFish_fast(initialFish: [Int], after days: Int) -> Int {
  func countFish(current: Int, days: Int, depth: Int) -> Int {
    if (current >= days) {
      return 1
    }
    
    return
      countFish(current: 6, days: days - current - 1, depth: depth) +
      countFish(current: 8, days: days - current - 1, depth: depth + 1)
  }

  return initialFish.reduce(0) { fishCount, fish in
    return fishCount + countFish(current: fish, days: days, depth: 0)
  }
}

private func parseInput(fileName: String) -> [Int] {
  guard let input = Helpers
          .contentsOfFile(name: fileName, type: "txt") else {
            return []
          }
  
  return input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: ",")
    .map { Int($0) }
    .compactMap { $0 }
}
