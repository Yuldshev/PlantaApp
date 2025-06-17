import SwiftUI

struct MainView: View {
  @ObservedObject var vm: MainViewModel
  
  var body: some View {
    ZStack {
      VStack {
        switch vm.tab {
          case .home:
            HomeView(vm: vm)
              .transition(.move(edge: .bottom).combined(with: .opacity))
          case .search:
            SearchView()
              .transition(.move(edge: .bottom).combined(with: .opacity))
          case .order:
            CartView(vm: vm)
              .transition(.move(edge: .bottom).combined(with: .opacity))
          case .profile:
            ProfileView(vm: vm)
              .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .animation(.easeInOut, value: vm.tab)
      
      VStack {
        Spacer()
        CustomTabView(selectedTab: $vm.tab)
      }
    }
  }
}

#Preview {
  MainView(vm: MainViewModel())
    .previewRouter()
}
