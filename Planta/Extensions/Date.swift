import Foundation

extension Date {
  func formattedWithOrdinalSuffix() -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: self)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM"
    let prefix = formatter.string(from: self)
    
    let suffix: String
    switch day {
      case 11...13: suffix = "th"
      default:
        switch day % 10 {
          case 1: suffix = "st"
          case 2: suffix = "nd"
          case 3: suffix = "rd"
          default: suffix = "th"
        }
    }
    
    return "\(prefix) \(day)\(suffix)"
  }
}
