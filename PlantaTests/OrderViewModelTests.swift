import Foundation
import XCTest
@testable import Planta

@MainActor
final class OrderViewModelTests: XCTestCase {
  
  private func makeSUT() -> OrderViewModel {
    let vm = OrderViewModel()
    vm.pin = "1234 1234 1234 1234"
    vm.cardName = "John Doe"
    vm.cvc = "123"
    vm.expirationDate = Date()
    return vm
  }
  
  func test_validate_withValidData_shouldReturnTrue() async {
    let vm = makeSUT()
    XCTAssertTrue(vm.isValid)
    XCTAssertNil(vm.errorMessage)
  }
  
  func test_validate_withShortPin_shouldReturnFalse() async {
    let vm = makeSUT()
    await MainActor.run { vm.pin = "1234" }
    XCTAssertFalse(vm.isValid)
  }
  
  func test_validate_withEmptyCardName_shouldReturnFalse() async {
    let vm = makeSUT()
    await MainActor.run { vm.cardName = "   " }
    XCTAssertFalse(vm.isValid)
  }
  
  func test_validate_withInvalidCVC_shouldReturnFalse() async {
    let vm = makeSUT()
    await MainActor.run { vm.cvc = "1a3" }
    XCTAssertFalse(vm.isValid)
    
    await MainActor.run { vm.cvc = "12" }
    XCTAssertFalse(vm.isValid)
  }
}
