import Foundation

enum AppRoute {
  case auth, home
}

@MainActor
final class AppState: ObservableObject {
  @Published var currentRoute: AppRoute
  @Published var user: User?
  
  init() {
    if let userData = UserDefaults.standard.data(forKey: "currentUser"),
    let user = try? JSONDecoder().decode(User.self, from: userData) {
      self.user = user
      self.currentRoute = user.email.isEmpty ? .auth : .home
    } else {
      self.currentRoute = .auth
      self.user = nil
    }
  }
  
  func updateUser(email: String, name: String? = nil, address: String? = nil, phone: String? = nil) {
    let newUser = User(email: email, name: name, address: address, phone: phone)
    self.user = newUser
    
    if let userData = try? JSONEncoder().encode(newUser) {
      UserDefaults.standard.set(userData, forKey: "currentUser")
    }
    
    currentRoute = email.isEmpty ? .auth : .home
  }
  
  func logout() {
    user = nil
    currentRoute = .auth
    UserDefaults.standard.removeObject(forKey: "currentUser")
  }
}
