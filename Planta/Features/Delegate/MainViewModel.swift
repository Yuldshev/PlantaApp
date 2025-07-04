import Foundation

@MainActor
final class MainViewModel: ObservableObject {
  @Published var tab: Tab = .home
  
}

//MARK: - enum Tab
enum Tab: String, CaseIterable {
  case home, search, order, profile
  
  var iconName: String {
    switch self {
      case .home: return "home"
      case .search: return "search"
      case .order: return "cart"
      case .profile: return "user"
    }
  }
}
