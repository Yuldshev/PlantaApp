import SwiftUI

struct InlineNavigation: ViewModifier {
  @Environment(\.dismiss) var dismiss
  let title: String
  
  func body(content: Content) -> some View {
    content
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        //Header
        ToolbarItem(placement: .principal) {
          Text(title.uppercased())
            .sub(type: .bold)
        }
        
        //Back button
        ToolbarItem(placement: .topBarLeading) {
          Button(action: { dismiss() }) {
            Image(.chevronLeft)
              .foregroundStyle(.black)
          }
        }
        
        //Cart button
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

extension View {
  public func inlineNavigation(title: String) -> some View {
    modifier(InlineNavigation(title: title))
  }
}
