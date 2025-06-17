import SwiftUI
import SwiftfulRouting
import SwiftfulRecursiveUI

struct TESTTEST: View {
  @Environment(\.router) var router
  
  var body: some View {
    RouterView { _ in
      VStack {
        Text("Main Screen")
        CustomButton(text: "Screen 2") {
          router.showScreen(.push) { _ in Screen2() }
        }
      }
    }
    .padding(.horizontal, 48)
  }
}

struct Screen2: View {
  @Environment(\.router) var router
  
  var body: some View {
    CustomButton(text: "Screen 3") {
      router.showScreen(.push) { _ in Screen3() }
    }
    .padding(.horizontal, 48)
  }
}

struct Screen3: View {
  @Environment(\.router) var router
  
  var body: some View {
    CustomButton(text: "Screen 4") {
      router.showScreen(.push) { _ in Screen4() }
    }
    .padding(.horizontal, 48)
  }
}

struct Screen4: View {
  @Environment(\.router) var router
  
  var body: some View {
    CustomButton(text: "Exit", color: .black) {
//      router.dismissModule()
      router.dismissPushStack()
    }
    .padding(.horizontal, 48)
  }
}
#Preview {
  TESTTEST()
    .previewRouter()
}
