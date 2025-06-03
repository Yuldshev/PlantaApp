import SwiftUI

struct MainView: View {
  @StateObject var vm = CartViewModel()
  @State private var selectedTab: Tab = .home
  
  init() { UITabBar.appearance().isHidden = true }
  
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
            CartView()
              .transition(.move(edge: .bottom).combined(with: .opacity))
              .environmentObject(vm)
          case .profile:
            ProfileView()
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
  MainView()
    .previewRouter()
    .environmentObject(CartViewModel())
}
