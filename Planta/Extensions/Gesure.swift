import SwiftUI

struct SwipeBackGesure: ViewModifier {
  @Environment(\.router) var router
  @GestureState private var dragOffset: CGFloat = 0
  
  func body(content: Content) -> some View {
    content
      .contentShape(Rectangle())
      .gesture(
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
          .updating($dragOffset) { value, state, _ in
            if value.translation.width > 0 && abs(value.translation.height) < 50 {
              state = value.translation.width
            }
          }
          .onEnded { value in
            if value.translation.width > 80 && abs(value.translation.height) < 50 {
              router.dismissScreen()
            }
          }
        )
  }
}

extension View {
  func swipeBackGesture() -> some View {
    self.modifier(SwipeBackGesure())
  }
}
