import SwiftUI

struct MainView: View {
  @ObservedObject var appState: AppState
  @ObservedObject var authVM: AuthViewModel
  
  @StateObject var orderVM = OrderViewModel()
  @StateObject var cartVM = CartViewModel()
  @StateObject var mainVM = MainViewModel()
  
  var body: some View {
    ZStack {
      VStack {
        Group {
          switch mainVM.tab {
            case .home: HomeView(cartVM: cartVM, orderVM: orderVM, mainVM: mainVM)
            case .search: SearchView(cartVM: cartVM, mainVM: mainVM)
            case .order: CartView(cartVM: cartVM, orderVM: orderVM, authVM: authVM)
            case .profile: ProfileView(appState: appState, authVM: authVM, orderVM: orderVM)
          }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut, value: mainVM.tab)
      }
      
      VStack {
        Spacer()
        CustomTabView(selectedTab: $mainVM.tab)
      }
    }
  }
}

//MARK: - Preview
#Preview {
  MainView(appState: AppState(), authVM: AuthViewModel(), orderVM: OrderViewModel())
    .previewRouter()
}
