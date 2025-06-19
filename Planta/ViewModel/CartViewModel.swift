import Foundation

@MainActor
final class CartViewModel: ObservableObject {
  @Published var items: [Cart] = []
  
  private var service: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.service = service
  }
  
  func add(_ item: Goods) {
    if let index = items.firstIndex(where: { $0.goods == item }) {
      items[index].quantity += 1
    } else {
      items.append(Cart(goods: item, quantity: 1))
    }
    
    Task { await saveCart() }
  }
  
  func remove(_ item: Goods) {
    guard let index = items.firstIndex(where: { $0.goods == item }) else { return }
    
    if items[index].quantity > 1 {
      items[index].quantity -= 1
    } else {
      items.remove(at: index)
    }
    
    Task { await saveCart() }
  }
  
  func clear() {
    items.removeAll()
    Task { await service.removeCache(for: .cart) }
  }
  
  // MARK: - Data persistence
  func saveCart() async {
    await service.saveCache(items, key: .cart)
  }
  
  func loadCart() async {
    if let saveItems = await service.loadCache(key: .cart, as: [Cart].self) {
      items = saveItems
    }
  }
  
  var totalCount: Int {
    items.reduce(0) { $0 + $1.quantity }
  }
  
  var totalPrice: Double {
    items.reduce(0) { $0 + (Double($1.quantity) * $1.goods.price) }
  }
}
