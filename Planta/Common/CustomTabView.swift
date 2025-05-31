import SwiftUI

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

struct CustomTabView: View {
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      HStack {
        ForEach(Tab.allCases, id: \.rawValue) { tab in
          Spacer()
          
          TabIcon(tab: tab, isSelected: selectedTab == tab) {
            selectedTab = tab
          }
          
          Spacer()
        }
      }
    }
    .padding(.vertical)
    .background(.white)
    .frame(height: 68)
    .animation(.spring(), value: selectedTab)
  }
}

struct TabIcon: View {
  let tab: Tab
  let isSelected: Bool
  let onTap: () -> Void
  
  var body: some View {
    VStack {
      Image(tab.iconName)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .onTapGesture {
          withAnimation(.spring()) {
            onTap()
          }
        }
      
      if isSelected {
        Circle()
          .frame(width: 4)
      }
    }
  }
}

#Preview {
  CustomTabView(selectedTab: .constant(.home))
    .background(.red)
}
