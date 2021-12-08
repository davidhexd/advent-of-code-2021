import Foundation

public let day6 = Day(name: "six") {
  part1()
  part2()
}

private func part1() {
  print("Part 1: \(modelFish_slow(initialFish: parseInput(fileName: "day-6"), after: 80))")
}

private func part2() {
  print("Part 2: \(modelFish_fast(initialFish: parseInput(fileName: "day-6"), after: 256))")
}

let debug = false


private func modelFish_slow(initialFish: [Int], after days: Int) -> Int {
  if debug {
    print("\(days): \(initialFish)")
  }
  
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
    if debug {
      print("\(days - day): \(newFish)")
    }
    return newFish
  }
  return finalFish.count
}

private func modelFish_fast(initialFish: [Int], after days: Int) -> Int {
  struct Request: Hashable, CustomStringConvertible {
    let current: Int
    let daysRemaining: Int
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(current)
      hasher.combine(daysRemaining)
    }
    
    var description: String {
      return "🐟 \(current): \(daysRemaining) days"
    }
  }
  
  var requests: [Request: Int] = [:]
  
  func coundChildren(current: Int, days: Int, depth: Int) -> Int {
    let request = Request(current: current, daysRemaining: days)
    if (current >= days) {
      if debug {
        print("\(depth.padding())\(request) -> 0")
      }
      return 0
    }
    
    if let fish = requests[request] {
      if debug {
        print("\(depth.padding())\(request) -> 0 (cached)")
      }
      return fish
    }
    
    let numChildren: Int = 1 + Int(floorf(Float(days - current) / Float(7))) + {
      if (days - current) % 7 == 0 {
        // If hit zero on the last day, subtract one since child spawns on next day
        return -1
      } else {
        return 0
      }
    }()
                                   
    let requestFish = numChildren
    
    var additionalReqs = [Request]()
    var shouldContinue = true
    var currentDays = days - current - 1
    while (shouldContinue) {
      if (currentDays < 0) {
        shouldContinue = false
      } else {
        additionalReqs.append(Request(current: 8, daysRemaining: currentDays))
        currentDays = currentDays - 7
      }
    }
    
    if debug {
      print("\(depth.padding())\(request) with \(numChildren) makes \(additionalReqs.count) more requests \(additionalReqs)")
    }
    
    var totalFish = requestFish

    additionalReqs.reversed().forEach { request in
      let numChildrenOfChild = coundChildren(current: request.current, days: request.daysRemaining, depth: depth + 1)
      totalFish += numChildrenOfChild
    }
    
    if debug {
      print("🐟 \(current): \(days) days -> \(totalFish) - calculated")
    }
    
    requests[request] = totalFish

    return totalFish
  }

  return initialFish.reduce(0) { fishCount, fish in
    return fishCount + coundChildren(current: fish, days: days, depth: 0) + 1
  }
}

extension Int {
  func padding() -> String {
    (0..<self).map { _ in " " }.joined(separator: "")
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
