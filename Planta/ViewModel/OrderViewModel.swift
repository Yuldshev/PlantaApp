import Foundation

final class OrderViewModel: ObservableObject {
  @Published var info: [InfoType: String] = [:]
  @Published var deliveryMethod: DeliveryMethod = .fast
  @Published var paymentMethod: PaymentMethod = .creditCard
  @Published var creditCardData: [CreditCard: String] = [:]
  
  private var dataService: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
    InfoType.allCases.forEach { info[$0] = "" }
    CreditCard.allCases.forEach { creditCardData[$0] = "" }
  }
  
  var formIsValid: Bool {
    InfoType.allCases.allSatisfy { type in
      let value = info[type]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      return !value.isEmpty && (type != .email || value.contains("@"))
    }
  }
  
  var cardFormIsValid: Bool {
    CreditCard.allCases.allSatisfy { type in
      let value = creditCardData[type]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      return !value.isEmpty
    }
  }
  
  func loadEmailFromCache() {
    print("Attempting to load user from cache")
    if let cachedUser = dataService.loadCache(key: .user, as: User.self) {
      print("Successfully loaded user: \(cachedUser)")
      info[.email] = cachedUser.email
    } else {
      print("Failed to load user from cache")
    }
  }
}

enum InfoType: String, CaseIterable {
  case name, email, address, phone
}

enum DeliveryMethod: String, CaseIterable {
  case fast, standard
  
  var estimatedDate: Date {
    let days = self == .fast ? 7 : 16
    return Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
  }
  
  var formattedDate: String {
    estimatedDate.formatted()
  }
}

enum PaymentMethod: String, CaseIterable {
  case creditCard, paypal, applePay
}

enum CreditCard: String, CaseIterable {
  case pin, cardName, expirationDate, cvc
}
