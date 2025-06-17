import SwiftUI

struct EditInfoView: View {
  @ObservedObject var authVM: AuthViewModel
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 15) {
        Text("The information will be saved for the next purchase. Click on the details to edit.")
          .body(type: .regular)
          
        VStack(spacing: 15) {
          CustomTextField(placeholder: "Name", isBold: false, height: 0.6, text: $authVM.name)
          CustomTextField(placeholder: "Email", isBold: false, height: 0.6, text: $authVM.email)
          CustomTextField(placeholder: "Address", isBold: false, height: 0.6, text: $authVM.address)
          CustomTextField(placeholder: "Phone", isBold: false, height: 0.6, text: $authVM.phone)
            .onChange(of: authVM.phone) { _, newValue in
              let formatted = newValue.formattedPhoneNumber()
              if formatted != newValue {
                authVM.phone = formatted
              }
            }
        }
        .padding(.vertical, 15)
        
        if let error = authVM.errorMessage {
          Text(error)
            .body(type: .regular)
            .foregroundStyle(.red)
        }
      }
      .padding(.vertical, 15)
      .padding(.horizontal, 48)
      .inlineNavigation(title: "Edit Information", isShow: false)
    }
    .overlay(alignment: .bottom) {
      CustomButton(text: "Save", color: authVM.isValid ? .accent : .appLightGray) {
        Task { await authVM.saveFromData() }
        router.dismissScreen()
      }
      .disabled(!authVM.isValid)
      .padding(.horizontal, 48)
    }
  }
}

#Preview {
  EditInfoView(authVM: AuthViewModel())
    .previewRouter()
}
