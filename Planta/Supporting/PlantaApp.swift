import SwiftUI
import SwiftfulRouting

@main
struct PlantaApp: App {
  @StateObject var appState = AppState()
  @StateObject var authVM = AuthViewModel()
  
  var body: some Scene {
    WindowGroup {
      Group {
        switch appState.currentRoute {
          case .auth: RouterView { _ in
            AuthView(appState: appState, authVM: authVM)
              .transition(.blurReplace)
              .preferredColorScheme(.light)
          }
          case .home: RouterView { _ in
            MainView(appState: appState, authVM: authVM)
              .transition(.blurReplace)
              .preferredColorScheme(.light)
          }
        }
      }
      .animation(.easeInOut, value: appState.currentRoute)
    }
  }
}

