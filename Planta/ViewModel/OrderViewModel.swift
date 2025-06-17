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
  
  @Published private(set) var isValid = false
  @Published var errorMessage: String?
  
  private var dataService: DataServiceProtocol
  private var validationService: ValidationServiceProtocol
  
  init(service: DataServiceProtocol = DataService(), validationService: ValidationServiceProtocol = ValidationService()) {
    self.dataService = service
    self.validationService = validationService
    validateAllFields()
  }
  
  func validateAllFields() {
    let result = validationService.validateCard(pin: pin, cardName: cardName, cvc: cvc)
    self.isValid = result.isFormValid
    self.errorMessage = result.error
  }
  
  // MARK: - Data persistence
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


