import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
  @Published var email = "" { didSet { validateAllFields() } }
  @Published var name = "" { didSet { validateAllFields() } }
  @Published var address = "" { didSet { validateAllFields() } }
  @Published var phone = "" { didSet { validateAllFields() } }
  @Published var errorMessage: String?
  @Published private(set) var isValid = false
  
  private var dataService: DataServiceProtocol
  private var validationService: ValidationServiceProtocol
  
  init(service: DataServiceProtocol = DataService(), validationService: ValidationServiceProtocol = ValidationService()) {
    self.dataService = service
    self.validationService = validationService
    validateAllFields()
  }
  
  // MARK: - Computed validation
  private func validateAllFields() {
    let result = validationService.validateUser(email: email, name: name, address: address, phone: phone)
    self.isValid = result.isValid
    self.errorMessage = result.error
  }
  
  // MARK: - Data persistence
  func saveFromData() async {
    let user = User(email: email, name: name, address: address, phone: phone)
    await dataService.saveCache(user, key: .user)
    print("✅ User saved: \(user)")
  }
  
  func loadFromData() async {
    guard let user = await dataService.loadCache(key: .user, as: User.self) else { return }
    
    await MainActor.run {
      email = user.email
      name = user.name ?? ""
      address = user.address ?? ""
      phone = user.phone ?? ""
    }
  }
}
