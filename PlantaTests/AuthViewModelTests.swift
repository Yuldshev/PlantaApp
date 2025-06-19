import XCTest
@testable import Planta

final class AuthViewModelTests: XCTestCase {
  
  func test_validateAllFields_withValidInput_shouldSetIsValidTrue() async throws {
    let vm = await AuthViewModel()
    
    await MainActor.run {
      vm.email = "fazliddin@gmail.com"
      vm.name = "Fazliddin"
      vm.address = "Tashkent"
      vm.phone = "+99890 980-32-36"
    }
    
    try await Task.sleep(for: .microseconds(10))
    
    await MainActor.run {
      XCTAssertTrue(vm.isValid)
      XCTAssertNil(vm.errorMessage)
    }
  }
  
  func test_validateAllFields_withInvalidInput_shouldSetIsValidFalse() async throws {
    let vm = await AuthViewModel()
    
    await MainActor.run {
      vm.email = "fazliddin"
      vm.name = "Fazliddin"
      vm.address = "Tashkent"
      vm.phone = "+99890 980-32-36"
    }
    
    try await Task.sleep(for: .microseconds(10))
    
    await MainActor.run {
      XCTAssertFalse(vm.isValid)
      XCTAssertNotNil(vm.errorMessage)
    }
  }
}
