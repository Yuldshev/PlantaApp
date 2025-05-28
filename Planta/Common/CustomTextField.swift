import SwiftUI

struct CustomTextField: View {
  var placeholder: String
  var color: Color
  @Binding var text: String
  
  var body: some View {
    TextField(placeholder, text: $text)
      .sub(type: .regular)
    CustomDivider(color: color, height: 1.5)
      
  }
}
