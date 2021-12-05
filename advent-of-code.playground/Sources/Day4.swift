import Foundation
import CoreGraphics

public let day4 = Day(name: "four") {
  let (game, inputs) = parseGameInput(name: "day-4")
  print("Part 1")
  if let (winningBoard, input) = game.processInputs(inputs) {
    let sumOfUnmarkedNumbers = winningBoard.valueToNumber.values.filter { number in
      return !number.isMarked
    }.reduce(0) { partialResult, number in
      return partialResult + number.value
    }

    print(winningBoard)
    print(sumOfUnmarkedNumbers * input)
  } else {
    print("no winner \n\(game)")
  }
  
  print("\nPart 2")
  let (game2, inputs2) = parseGameInput(name: "day-4")
  if let (winningBoard, input) = game2.processInputsPart2(inputs2) {
    let sumOfUnmarkedNumbers = winningBoard.valueToNumber.values.filter { number in
      return !number.isMarked
    }.reduce(0) { partialResult, number in
      return partialResult + number.value
    }
    
    print(winningBoard)
    print(sumOfUnmarkedNumbers * input)
  } else {
    print("no winner \n\(game2)")
  }
}


struct Board: CustomStringConvertible, Equatable {
  
  static func == (lhs: Board, rhs: Board) -> Bool {
    lhs.numbers == rhs.numbers
  }
  
  class Number: CustomStringConvertible, Equatable {
    static func == (lhs: Board.Number, rhs: Board.Number) -> Bool {
      lhs.value == rhs.value
    }
    
    internal init(isMarked: Bool, value: Int) {
      self.isMarked = isMarked
      self.value = value
    }
    
    var isMarked: Bool
    let value: Int
    
    var description: String {
      return "\(value): \(isMarked ? "✅" : "⬜️")"
    }
  }
  
  let numbers: [[Number]]
  let valueToNumber: [Int: Number]
  
  init(numbers: [[Int]]) {
    var valueToNumber: [Int: Number] = [:]
    
    self.numbers = numbers.map { row in
      row.map { value in
        let number = Number(isMarked: false, value: value)
        valueToNumber[value] = number
        return number
      }
    }
    
    self.valueToNumber = valueToNumber
  }
  
  init(numbers: [[Number]], valueToNumber: [Int: Number]) {
    self.numbers = numbers
    self.valueToNumber = valueToNumber
  }
  
  enum Bingo {
    case horizontal(y: Int)
    case vertical(x: Int)
    case topLeftDiagonal
    case bottomLeftDiagonal
    
    static var scenarios: [Bingo] = {
      var _scenarios: [Bingo] = []
      _scenarios.append(contentsOf: (0..<5).map { Bingo.horizontal(y: $0) })
      _scenarios.append(contentsOf: (0..<5).map { Bingo.vertical(x: $0) })
//      _scenarios.append(contentsOf: [
//        .topLeftDiagonal,
//        .bottomLeftDiagonal
//      ])
      return _scenarios
    }()
  }
  
  func mark(input: Int) {
    guard let number = valueToNumber[input] else {
      return
    }
    
    number.isMarked = true
  }
  
  func numbersToCheck(_ bingo: Bingo) -> [Number] {
    switch bingo {
    case .horizontal(let y):
      return numbers[y]
    case .vertical(let x):
      return numbers.map { row in
        return row[x]
      }
    case .topLeftDiagonal:
      return [numbers[0][0], numbers[1][1], numbers[2][2], numbers[3][3], numbers[4][4]]
    case .bottomLeftDiagonal:
      return [numbers[0][4], numbers[1][3], numbers[2][2], numbers[3][1], numbers[4][0]]
    }
  }
  
  func hasBingo(_ bingo: Bingo) -> Bool {
    return numbersToCheck(bingo).reduce(true) { partialResult, number in
      return partialResult && number.isMarked
    }
  }
  
  func bingos() -> [Bingo] {
    Bingo.scenarios.filter { self.hasBingo($0) }
  }
  
  var description: String {
    return numbers.map { row in
      return row.map { number in
        return "\(number)"
      }.joined(separator: "\t")
    }.joined(separator: "\n")
  }
}

struct Game: CustomStringConvertible {
  let boards: [Board]
  
  var description: String {
    return boards.map { board in
      "\(board)"
    }.joined(separator: "\n\n")
  }
  
  func processInputs(_ inputs: [Int]) -> (Board, Int)? {
    for input in inputs {
      for board in boards {
        board.mark(input: input)
        
        if board.bingos().count > 0 {
          return (board, input)
        }
      }
    }
    
    return nil
  }
  
  func processInputsPart2(_ inputs: [Int]) -> (Board, Int)? {
    var boardsToCheck = boards
    var winningBoards = [(Board, Int)]()
    for input in inputs {
      var copyOfBoardsToCheck = boardsToCheck
      for board in boardsToCheck {
        board.mark(input: input)

        if board.bingos().count > 0 {
          winningBoards.append((board, input))
        }
      }
      
      copyOfBoardsToCheck.removeAll { board in
        winningBoards.contains { (_board, _) in
          _board == board
        }
      }
      
      boardsToCheck = copyOfBoardsToCheck
    }
    
    return winningBoards.last
  }
}

private func parseGameInput(name: String) -> (Game, [Int]) {
  guard let rawGameInput = Helpers.contentsOfFile(name: name, type: "txt") else {
    fatalError()
  }
  
  let lines = rawGameInput.components(separatedBy: "\n")
    .filter { !$0.isEmpty }
  
  // first line is inputs
  let inputs = lines[0].components(separatedBy: ",").map { Int($0)! }
  
  // subsequent lines are boards
  let boards = Array(lines.suffix(from: 1))
    .chunked(into: 5)
    .map { boardLines in
      boardLines.map { boardLine in
        boardLine
          .components(separatedBy: .whitespaces)
          .filter { !$0.isEmpty }
          .map { Int($0)! }
      }
    }.map { boardNumbers in
      Board(numbers: boardNumbers)
    }
  
  return (Game(boards: boards), inputs)
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
