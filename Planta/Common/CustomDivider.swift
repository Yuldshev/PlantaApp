import SwiftUI

struct CustomDivider: View {
  var color: Color = .appLightGray
  var height: CGFloat = 1
  
  var body: some View {
    Rectangle()
      .fill(color)
      .frame(height: height)
      .edgesIgnoringSafeArea(.horizontal)
  }
}
