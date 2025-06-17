import SwiftUI
import SwiftfulRouting

@main
struct PlantaApp: App {
  @StateObject var vm = MainViewModel()
  
  var body: some Scene {
    WindowGroup {
      VStack {
        if vm.appState.currentRoute == .auth {
          RouterView { _ in
            AuthView(vm: vm)
              .preferredColorScheme(.light)
          }
        } else {
          RouterView { _ in
            MainView(vm: vm)
              .preferredColorScheme(.light)
          }
        }
      }
    }
  }
}
