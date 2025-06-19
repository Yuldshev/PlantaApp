import SwiftUI

struct CustomButton: View {
  var text: String = ""
  var color: Color = .accent
  var action: () -> Void = {}
  
  var body: some View {
    Button(action: action) {
      Text(text)
        .sub(type: .bold)
        .foregroundStyle(.white)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
  }
}

#Preview {
  CustomButton(text: "Sign in")
}
