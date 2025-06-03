import SwiftUI

struct InlineNavigation: ViewModifier {
  @Environment(\.dismiss) var dismiss
  let title: String
  let isShow: Bool
  
  func body(content: Content) -> some View {
    content
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(title.uppercased())
            .sub(type: .bold)
        }
        
        ToolbarItem(placement: .topBarLeading) {
          Button(action: { dismiss() }) {
            Image(.chevronLeft)
              .foregroundStyle(.black)
          }
        }
        
        if isShow {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}) {
              Image(.cart)
                .foregroundStyle(.black)
                .padding(.trailing, 14)
            }
          }
        }
      }
  }
}

struct OrderNavigation: ViewModifier {
  @Environment(\.dismiss) var dismiss
  let action: AnyView
  
  func body(content: Content) -> some View {
    content
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: { dismiss() }) {
            Image(.chevronLeft)
              .foregroundStyle(.black)
          }
        }
        
        ToolbarItem(placement: .principal) {
          Text("CART")
            .sub(type: .bold)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          action
        }
      }
  }
}

extension View {
  public func inlineNavigation(title: String, isShow: Bool) -> some View {
    modifier(InlineNavigation(title: title, isShow: isShow))
  }
  
  public func orderNavigation<T: View>(@ViewBuilder action: () -> T) -> some View {
    modifier(OrderNavigation(action: AnyView(action())))
  }
}
