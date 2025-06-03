import Foundation

final class CartViewModel: ObservableObject {
  @Published private(set) var items: [Goods: Int] = [:]
  
  private var dataService: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
    loadCart()
  }
  
  func add(_ item: Goods) {
    items[item, default: 0] += 1
    saveCart()
  }
  
  func remove(_ item: Goods) {
    guard let currentCount = items[item], currentCount > 1 else {
      items[item] = nil
      saveCart()
      return
    }
    
    items[item] = currentCount - 1
    saveCart()
  }
  
  func clear() {
    items.removeAll()
    dataService.removeCache(for: .cart)
  }
  
  var totalCount: Int {
    items.values.reduce(0, +)
  }
  
  var totalPrice: Double {
    items.reduce(0) { $0 + Double($1.value) * $1.key.price }
  }
  
  var orderedItems: [(items: Goods, count: Int)] {
    items.map { ($0.key, $0.value) }
  }
  
  private func saveCart() {
    let saveItems = items.map { CartItem(goods: $0.key, count: $0.value) }
    print("Saving items: \(saveItems.map { $0.goods.name })")
    dataService.saveCache(saveItems, key: .cart)
  }
  
  func loadCart() {
    if let savedItems = dataService.loadCache(key: .cart, as: [CartItem].self) {
      print("Loaded items: \(savedItems.map { $0.goods.name })")
      var result: [Goods: Int] = [:]
      savedItems.forEach { result[$0.goods] = $0.count }
      items = result
    }
  }
}
