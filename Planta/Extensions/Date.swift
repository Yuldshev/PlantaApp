import Foundation

extension Date {
  func formatted() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    return dateFormatter.string(from: self)
  }
}
