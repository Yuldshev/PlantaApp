import XCTest
@testable import Planta

@MainActor
final class AppStateTests: XCTestCase {
  private let key = "currentUser"
  private var defaults: UserDefaults { .standard }
  
  override func tearDown() {
    defaults.removeObject(forKey: key)
    super.tearDown() 
  }
  
  func test_init_noSavedUser_shouldStartInAuthRoute() {
    let state = AppState()
    
    XCTAssertEqual(state.currentRoute, .auth)
    XCTAssertNil(state.user)
  }
  
  func test_init_savedUser_shouldStartInHomeRoute() throws {
    let saved = User(email: "test@test.com", name: nil, address: nil, phone: nil)
    defaults.set(try JSONEncoder().encode(saved), forKey: key)
    
    let state = AppState()
    
    XCTAssertEqual(state.currentRoute, .home)
    XCTAssertEqual(state.user, saved)
  }
  
  func test_updateUser_validEmail_shouldSaveAndSwitchToHome() {
    let state = AppState()
    state.updateUser(email: "test@test.com")
    
    XCTAssertEqual(state.currentRoute, .home)
    XCTAssertEqual(state.user?.email, "test@test.com")
    
    let data = defaults.data(forKey: key)
    XCTAssertNotNil(data)
  }
  
  func test_updateUser_emptyEmail_shouldStayInAuth() {
    let state = AppState()
    state.updateUser(email: "")
    
    XCTAssertEqual(state.currentRoute, .auth)
    XCTAssertTrue(state.user?.email.isEmpty ?? false)
  }
  
  func test_logout_shouldClearUserAndReturnToAuth() {
    let state = AppState()
    state.updateUser(email: "test@test.com")
    state.logout()
    
    XCTAssertEqual(state.currentRoute, .auth)
    XCTAssertNil(state.user)
    XCTAssertNil(defaults.data(forKey: key))
  }
}
