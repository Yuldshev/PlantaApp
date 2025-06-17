import Foundation

struct Order: Codable {
  let goods: [Cart]
  let user: User
  let card: Card
  let deliveryMethod: DeliveryMethod
  let paymentMethod: PaymentMethod
  let date: Date
}

//MARK: - DeliveryMethod
enum DeliveryMethod: String, CaseIterable, Codable {
  case fast, standard
  
  var estimatedDate: Date {
    let days = self == .fast ? 7 : 16
    return Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
  }
  
  var formattedDate: String {
    estimatedDate.formatted()
  }
}

//MARK: - PaymentMethod
enum PaymentMethod: String, CaseIterable, Codable {
  case creditCard, paypal, applePay
}

