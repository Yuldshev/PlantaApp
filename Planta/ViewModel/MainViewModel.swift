import Foundation

@MainActor
final class MainViewModel: ObservableObject {
  @Published var cartVM = CartViewModel()
  @Published var orderVM = OrderViewModel()
  @Published var authVM = AuthViewModel()
  @Published var appState = AppState()
  
  @Published var tab: Tab = .home
}
