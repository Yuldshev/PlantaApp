import Foundation

final class OrderViewModel: ObservableObject {
  @Published var info: [InfoType: String] = [:]
  @Published var deliveryMethod: DeliveryMethod = .fast
  @Published var paymentMethod: PaymentMethod = .creditCard
  
  @Published var errorMessage = ""
  
  private var dataService: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
    loadEmailFromCache()
    InfoType.allCases.forEach { info[$0] = "" }
  }
  
  var formIsValid: Bool {
    allFieldsFilled && emailIsValid
  }
  
  private var allFieldsFilled: Bool {
    InfoType.allCases.allSatisfy { type in
      !(info[type]?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
  }
  
  private var emailIsValid: Bool {
    guard let email = info[.email] else { return false }
    return email.contains("@") && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  private func loadEmailFromCache() {
    if let cachedUser = dataService.loadCache(key: .user, as: User.self) {
      info[.email] = cachedUser.email
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
