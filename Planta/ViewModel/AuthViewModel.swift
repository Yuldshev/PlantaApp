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
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
  }
  
  // MARK: - Computed validation
  private func validateAllFields() {
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let emailValid = isValidEmail(email)
    let allFieldsFilled = !trimmedName.isEmpty && !trimmedAddress.isEmpty && !trimmedPhone.isEmpty
    
    Task { @MainActor in
      isValid = allFieldsFilled && emailValid
      
      if !allFieldsFilled {
        errorMessage = "All fields are required"
      } else if !emailValid {
        errorMessage = "Please enter a valid email"
      } else {
        errorMessage = nil
      }
    }
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmed)
  }
  
  // MARK: - Phone formatting
  func formatNumberPhone(with number: String) -> String {
    let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    guard cleanNumber.count == 9 || (cleanNumber.count == 12 && cleanNumber.hasPrefix("998")) else {
      return number
    }
    
    let nineDigitNumber = cleanNumber.count == 12
    ? String(cleanNumber.suffix(9))
    : cleanNumber
    
    let areaCode = String(nineDigitNumber.prefix(2))
    let firstPart = String(nineDigitNumber.dropFirst(2).prefix(2))
    let secondPart = String(nineDigitNumber.dropFirst(4).prefix(3))
    let thirdPart = String(nineDigitNumber.dropFirst(7))
    
    return "+998 \(areaCode) \(firstPart)-\(secondPart)-\(thirdPart)"
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
