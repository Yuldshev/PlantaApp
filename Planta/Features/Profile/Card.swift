import Foundation

struct Card: Identifiable, Hashable, Codable {
  var id = UUID()
  
  let pin: String
  let cardName: String
  let expirationDate: Date
  let cvc: String
}
