import Foundation

@MainActor
final class CartViewModel: ObservableObject {
  @Published var items: [Cart] = []
  
  private var service: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.service = service
  }
  
  func add(_ item: Goods) async {
    if let index = items.firstIndex(where: { $0.goods == item }) {
      items[index].quantity += 1
    } else {
      items.append(Cart(goods: item, quantity: 1))
    }
  }
  
  func remove(_ item: Goods) async {
    guard let index = items.firstIndex(where: { $0.goods == item }) else { return }
    
    if items[index].quantity > 1 {
      items[index].quantity -= 1
    } else {
      items.remove(at: index)
    }
  }
  
  func clear() {
    items.removeAll()
    service.removeCache(for: .cart)
  }
  
  //MARK: - Cache Service
  func saveCart(item: Goods, quantity: Int) async {
    let cartItem = Cart(goods: item, quantity: quantity)
    
    if let index = items.firstIndex(where: { $0.goods == item }) {
      items[index].quantity = quantity
    } else {
      items.append(cartItem)
    }
    
    await service.saveCache(items, key: .cart)
  }
  
  func loadCart() async {
    if let saveItems = await service.loadCache(key: .cart, as: [Cart].self) {
      items = saveItems
      print("Load cache: \(items)")
    }
  }
  
  var totalCount: Int {
    items.reduce(0) { $0 + $1.quantity }
  }
  
  var totalPrice: Double {
    items.reduce(0) { $0 + (Double($1.quantity) * $1.goods.price) }
  }
}
