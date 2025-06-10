import SwiftUI

struct ProfileView: View {
  @Environment(\.router) var router
  @ObservedObject var appState: AppState
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 24) {
        ProfileUserInfoView()
        ProfileSection(title: "General", items: generalItem)
        ProfileSection(title: "Security", items: securityItem)
      }
      .padding(.horizontal, 48)
      .inlineNavigation(title: "Profile", isShow: false)
    }
  }
  
  private var generalItem: [ProfileMenuItem] {[
      ProfileMenuItem(title: "Edit Information") {
        router.showScreen(.push) { _ in EditInfoView() }
      },
      ProfileMenuItem(title: "Transaction History") {
        router.showScreen(.push) { _ in TransactionHistory() }
      },
      ProfileMenuItem(title: "Q & A") {
        router.showScreen(.push) { _ in QuestionView() }
      }]
  }
  
  private var securityItem: [ProfileMenuItem] {[
    ProfileMenuItem(title: "Terms & Policy") {
      router.showScreen(.push) { _ in TermsPolicyView() }
    },
    ProfileMenuItem(title: "Security Policy ") {
      router.showScreen(.push) { _ in SecurePolicyView() }
    },
    ProfileMenuItem(title: "Logout") {
      appState.logout()
    }]
  }
}

//MARK: - ProfileUserInfoView
struct ProfileUserInfoView: View {
  var body: some View {
    HStack(spacing: 26) {
      Circle()
        .fill(.accent.gradient)
        .frame(width: 40, height: 40)
      
      VStack(alignment: .leading) {
        Text("John Doe")
          .sub(type: .bold)
        Text("mail@example.com")
          .body(type: .regular)
          .foregroundStyle(.appLightGray)
      }
    }
    .padding(.vertical, 15)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

//MARK: - ProfileSection
struct ProfileSection: View {
  var title: String
  var items: [ProfileMenuItem]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      VStack(alignment: .leading) {
        Text(title)
          .sub(type: .regular)
          .foregroundStyle(.appLightGray)
        CustomDivider()
      }
      
      ForEach(items) { item in
        Button(action: item.action) {
          Text(item.title)
            .foregroundStyle(item.title == "Logout" ? .red : .black)
        }
        .sub(type: .regular)
      }
    }
    .padding(.vertical, 15)
  }
}

//MARK: - ProfileMenuItem
struct ProfileMenuItem: Identifiable {
  let id = UUID()
  let title: String
  let action: () -> Void
}

#Preview {
  ProfileView(appState: AppState())
    .previewRouter()
}
