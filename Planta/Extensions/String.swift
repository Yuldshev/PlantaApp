import SwiftUI

extension String {
  func formattedPhoneNumber() -> String {
    let cleanNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    guard cleanNumber.count == 9 || (cleanNumber.count == 12 && cleanNumber.hasPrefix("998")) else {
      return self
    }
    
    let nineDigitNumber = cleanNumber.count == 12 ? String(cleanNumber.suffix(9)) : cleanNumber
    
    let areaCode = String(nineDigitNumber.prefix(2))
    let firstPart = String(nineDigitNumber.dropFirst(2).prefix(2))
    let secondPart = String(nineDigitNumber.dropFirst(4).prefix(3))
    let thirdPart = String(nineDigitNumber.dropFirst(7))
    
    return "+998 \(areaCode) \(firstPart)-\(secondPart)-\(thirdPart)"
  }
  
  func formattedPin() -> String {
    let cleanNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    let trimmed = String(cleanNumber.prefix(16))
    
    var grouped = [String]()
    
    for i in stride(from: 0, to: trimmed.count, by: 4) {
      let start = trimmed.index(trimmed.startIndex, offsetBy: i)
      let end = trimmed.index(start, offsetBy: min(4, trimmed.distance(from: start, to: trimmed.endIndex)))
      grouped.append(String(trimmed[start..<end]))
    }
    
    return grouped.joined(separator: " ")
  }
}

