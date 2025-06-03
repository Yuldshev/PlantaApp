import SwiftUI

struct ConfirmClearModal: View {
  let onConfirm: () -> Void
  let onCancel: () -> Void
  
  var body: some View {
    VStack {
      Text("Delete all orders?")
        .sub(type: .bold)
      Text("This cannot be undone")
        .body(type: .regular)
        .foregroundStyle(.appLightGray)
        .padding(.bottom, 16)
      
      CustomButton(text: "YES", action: onConfirm)
      CustomButton(text: "Cancel", color: .appLightGray, action: onCancel)
    }
    .padding(24)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .padding(.horizontal, 16)
    .padding(.bottom, 32)
  }
}
