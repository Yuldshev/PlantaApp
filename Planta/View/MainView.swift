import SwiftUI

struct MainView: View {
  @ObservedObject var appState: AppState
  @StateObject var vm = CartViewModel()
  @State private var selectedTab: Tab = .home
  
  var body: some View {
    ZStack {
      VStack {
        switch selectedTab {
          case .home:
            HomeView(selectedTab: $selectedTab)
              .transition(.move(edge: .bottom).combined(with: .opacity))
              .environmentObject(vm)
          case .search:
            SearchView()
              .transition(.move(edge: .bottom).combined(with: .opacity))
          case .order:
            CartView(selectedTab: $selectedTab)
              .transition(.move(edge: .bottom).combined(with: .opacity))
              .environmentObject(vm)
          case .profile:
            ProfileView(appState: appState)
              .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .animation(.easeInOut, value: selectedTab)
      
      VStack {
        Spacer()
        CustomTabView(selectedTab: $selectedTab)
      }
    }
  }
}

#Preview {
  MainView(appState: AppState())
    .previewRouter()
    .environmentObject(CartViewModel())
}
