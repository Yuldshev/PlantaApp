import Foundation

extension Double {
  var formattedNumber: String {
    let intValue = Int(self)
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.groupingSeparator = ","
    numberFormatter.locale = Locale(identifier: "en_US")
    
    return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
  }
}
