import SwiftUI

@main
struct PlantaApp: App {
  @StateObject var appState = AppState()
  
  var body: some Scene {
    WindowGroup {
      VStack {
        if appState.currentRoute == .auth {
          AuthView(appState: appState)
        } else {
          MainView(appState: appState)
        }
      }
    }
  }
}
