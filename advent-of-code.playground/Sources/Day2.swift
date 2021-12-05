import Foundation

public let day2 = Day(name: "two") {
  let commands = parseInput()
  
  let finalPositionPart1 = commands.reduce(PositionPart1()) { currentPosition, command in
    return currentPosition.applying(command)
  }
  
  // negative y since depth is treated as a positive number
  print("part 1: \(finalPositionPart1.x * -finalPositionPart1.y)")
  
  let finalPositionPart2 = commands.reduce(PositionPart2()) { currentPosition, command in
    return currentPosition.applying(command)
  }
  
  // negative y since depth is treated as a positive number
  print("part 2: \(finalPositionPart2.x * -finalPositionPart2.y)")
}

struct PositionPart1 {
  init(x: Int = 0, y: Int = 0) {
    self.x = x
    self.y = y
  }
  
  let x: Int
  let y: Int
  
  func applying(_ command: Command) -> PositionPart1 {
    switch command.direction {
    case .down:
      return PositionPart1(x: x, y: y - command.distance)
    case .up:
      return PositionPart1(x: x, y: y + command.distance)
    case .forward:
      return PositionPart1(x: x + command.distance, y: y)
    }
  }
}

struct PositionPart2 {
  init(x: Int = 0, y: Int = 0, aim: Int = 0) {
    self.x = x
    self.y = y
    self.aim = aim
  }
  
  let x: Int
  let y: Int
  let aim: Int
  
  func applying(_ command: Command) -> PositionPart2 {
    switch command.direction {
    case .down:
      return PositionPart2(x: x, y: y, aim: aim + command.distance)
    case .up:
      return PositionPart2(x: x, y: y, aim: aim - command.distance)
    case .forward:
      return PositionPart2(x: x + command.distance, y: (y - (aim * command.distance)), aim: aim)
    }
  }
}

struct Command {
  enum Direction: String {
    case up
    case down
    case forward
  }
  
  let direction: Direction
  let distance: Int
}

private func parseInput() -> [Command] {
  guard let rawInput = Helpers.contentsOfFile(name: "day-2", type: "txt") else {
    fatalError()
  }
  
  return rawInput.split(separator: "\n").map { rawCommand -> Command? in
    let commandComponents = rawCommand.components(separatedBy: " ")
    
    guard
      commandComponents.count == 2,
      let direction = Command.Direction(rawValue: commandComponents[0]),
      let distance = Int(commandComponents[1]) else
    {
      fatalError()
    }
    
    return Command(
      direction: direction,
      distance: distance)
  }.compactMap { $0 }
}
