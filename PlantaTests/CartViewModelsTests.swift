import XCTest
@testable import Planta

@MainActor
final class CartViewModelsTests: XCTestCase {
  private var vm: CartViewModel!
  private let item = Goods(name: "Dracaena reflexa", category: .outdoor, image: "outdoor-1", price: 150)
  
  override func setUp() {
    super.setUp()
    vm = CartViewModel()
  }
  
  override func tearDown() {
    vm = nil
    super.tearDown()
  }
  
  func test_addNewItem_shouldAppendItemAndUpdateTotals() async {
    vm.add(item)
    
    XCTAssertEqual(vm.items.count, 1)
    XCTAssertEqual(vm.items.first?.quantity, 1)
    XCTAssertEqual(vm.totalCount, 1)
    XCTAssertEqual(vm.totalPrice, 150)
  }
  
  func test_addSameItemTwice_shouldIncreaseQuantity() async {
    vm.add(item)
    vm.add(item)
    
    XCTAssertEqual(vm.items.count, 1)
    XCTAssertEqual(vm.items.first?.quantity, 2)
    XCTAssertEqual(vm.totalCount, 2)
    XCTAssertEqual(vm.totalPrice, 300)
  }
  
  func test_removeItem_shouldDecreaseQuantityOrRemove() async {
    vm.add(item)
    vm.add(item)
    
    vm.remove(item)
    XCTAssertEqual(vm.items.first?.quantity, 1)
    XCTAssertEqual(vm.totalCount, 1)
    
    vm.remove(item)
    XCTAssertTrue(vm.items.isEmpty)
    XCTAssertEqual(vm.totalCount, 0)
  }
  
  func test_clear_shouldRemoveAllItemsAndResetTotals() async {
    vm.add(item)
    vm.add(item)
    
    vm.clear()
    
    XCTAssertTrue(vm.items.isEmpty)
    XCTAssertEqual(vm.totalCount, 0)
    XCTAssertEqual(vm.totalPrice, 0)
  }
}
