import SwiftUI

struct CustomTextField: View {
  var placeholder: String
  var isBold = true
  var color: Color = .appLightGray
  var height: CGFloat = 1.5
  @Binding var text: String
  
  var body: some View {
    VStack(spacing: 8) {
      TextField(placeholder, text: $text)
        .dynamicFont(type: .regular, isBold: isBold)
        
      CustomDivider(color: color, height: height)
    }
  }
}
