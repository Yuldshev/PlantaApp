import Foundation

final class OrderViewModel: ObservableObject {
  @Published private(set) var items: [Goods: Int] = [:]
  
  func add(_ item: Goods) {
    items[item, default: 0] += 1
  }
  
  func remove(_ item: Goods) {
    guard let currentCount = items[item], currentCount > 1 else {
      items[item] = nil
      return
    }
    
    items[item] = currentCount - 1
  }
  
  var totalCount: Int {
    items.values.reduce(0, +)
  }
  
  var totalPrice: Double {
    items.reduce(0) { $0 + Double($1.value) * $1.key.price }
  }
  
  func clear() {
    items.removeAll()
  }
}
