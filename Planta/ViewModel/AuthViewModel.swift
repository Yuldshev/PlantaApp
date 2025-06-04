import Foundation

final class AuthViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var errorMessage: String?
  
  private var dataService: DataServiceProtocol
  
  init(service: DataServiceProtocol = DataService()) {
    self.dataService = service
  }
  
  func validate() -> Bool {
    guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      errorMessage = "Email cannot be empty"
      return false
    }
    
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    
    if !isValid {
      errorMessage = "Please enter a valid email"
      return false
    }
    
    errorMessage = nil
    
    let user = User(name: "", email: email)
    print("Attempting to save user: \(user)")
    dataService.saveCache(user, key: .user)
    print("User saved successfully")
    
    return true
  }
}
