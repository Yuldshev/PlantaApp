import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
  @Published var orders: [Order] = []
  
  @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
  @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
  
  @Published var deliveryMethod: DeliveryMethod = .fast
  @Published var paymentMethod: PaymentMethod = .creditCard
  
  @Published var pin = ""
  @Published var cardName = ""
  @Published var expirationDate = Date()
  @Published var cvc = ""
  
  var isFormValid: Bool {
    validate()
  }
  
  private var dataService: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
  }
  
  func validate() -> Bool {
    let cleanPin = pin.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    guard cleanPin.count == 16 else { return false}
    guard !cardName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
    guard cvc.count == 3, Int(cvc) != nil else { return false }
    return true
  }
  
  func formattedPin(with number: String) -> String {
    let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    let trimmed = String(cleanNumber.prefix(16))
    
    var grouped = [String]()
    
    for i in stride(from: 0, to: trimmed.count, by: 4) {
      let start = trimmed.index(trimmed.startIndex, offsetBy: i)
      let end = trimmed.index(start, offsetBy: min(4, trimmed.distance(from: start, to: trimmed.endIndex)))
      grouped.append(String(trimmed[start..<end]))
    }
    
    return grouped.joined(separator: " ")
  }
  
  func saveData(user: User, goods: [Cart]) async {
    let card = Card(pin: pin, cardName: cardName, expirationDate: expirationDate, cvc: cvc)
    let newOrder = Order(goods: goods, user: user, card: card, deliveryMethod: deliveryMethod, paymentMethod: paymentMethod, date: Date())
    
    var currentOrders = await dataService.loadCache(key: .order, as: [Order].self) ?? []
    currentOrders.append(newOrder)
    await dataService.saveCache(currentOrders, key: .order)
    orders = currentOrders
  }
  
  func loadOrders() async {
    orders = await dataService.loadCache(key: .order, as: [Order].self) ?? []
  }
  
  func loadDebitCard() async {
    guard let orders = await dataService.loadCache(key: .order, as: [Order].self),
    let lastCard = orders.last?.card else { return }
    
    pin = lastCard.pin
    cardName = lastCard.cardName
    cvc = lastCard.cvc
    expirationDate = lastCard.expirationDate
  }
}


