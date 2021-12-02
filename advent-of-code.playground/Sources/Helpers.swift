import Foundation

public struct Day {
  let name: String
  let runner: () -> Void
  
  public func run() {
    print("")
    print("====== Day \(name): =====")
    runner()
    print("")
  }
}

public func contentsOfFile(name: String, type: String) -> String? {
  // get the file path for the file "test.json" in the playground bundle
  guard
    let filePath = Bundle.main.path(forResource: name, ofType: type),
    let contentData = FileManager.default.contents(atPath: filePath),
    let content = String(data: contentData, encoding: .utf8)
  else {
    return nil
  }
  
  return content
}
