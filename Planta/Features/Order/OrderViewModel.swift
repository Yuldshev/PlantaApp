import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
  @Published var orders: [Order] = []
  
  @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
  @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
  
  @Published var deliveryMethod: DeliveryMethod = .fast
  @Published var paymentMethod: PaymentMethod = .creditCard
  
  @Published var pin = "" { didSet { validateAllFields() } }
  @Published var cardName = "" { didSet { validateAllFields() } }
  @Published var expirationDate = Date()
  @Published var cvc = "" { didSet { validateAllFields() } }
  
  @Published private(set) var isValid = false
  @Published var errorMessage: String?
  
  private var dataService: DataServiceProtocol
  private var validationService: ValidationServiceProtocol
  
  init(service: DataServiceProtocol = DataService(), validationService: ValidationServiceProtocol = ValidationService()) {
    self.dataService = service
    self.validationService = validationService
  }
  
  private func validateAllFields() {
    let result = validationService.validateCard(pin: pin, cardName: cardName, cvc: cvc)
    switch result {
      case .success:
        isValid = true
        errorMessage = nil
      case .failure(let error):
        isValid = false
        errorMessage = error.localizedDescription
    }
  }
  
  // MARK: - Data persistence
  func saveData(goods: [Cart]) async {
    let newOrder = Order(goods: goods, deliveryMethod: deliveryMethod, paymentMethod: paymentMethod, date: Date())
    
    var currentOrders = await dataService.loadCache(key: .order, as: [Order].self) ?? []
    currentOrders.append(newOrder)
    await dataService.saveCache(currentOrders, key: .order)
    orders = currentOrders
    print(currentOrders)
  }
  
  func loadOrders() async {
    orders = await dataService.loadCache(key: .order, as: [Order].self) ?? []
  }
  
  func deleteAllOrders() async {
    await dataService.removeCache(for: .order)
    orders.removeAll()
  }
}


