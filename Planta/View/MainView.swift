import SwiftUI

struct MainView: View {
  @ObservedObject var vm: MainViewModel
  
  var body: some View {
    ZStack {
      VStack {
        Group {
          switch vm.tab {
            case .home: HomeView(vm: vm)
            case .search: SearchView()
            case .order: CartView(vm: vm)
            case .profile: ProfileView(vm: vm)
          }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut, value: vm.tab)
      }
      
      VStack {
        Spacer()
        CustomTabView(selectedTab: $vm.tab)
      }
    }
  }
}

//MARK: - Preview
#Preview {
  MainView(vm: MainViewModel())
    .previewRouter()
}
