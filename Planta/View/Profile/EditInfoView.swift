import SwiftUI

struct EditInfoView: View {
  @ObservedObject var avm: AuthViewModel
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 15) {
        Text("The information will be saved for the next purchase. Click on the details to edit.")
          .body(type: .regular)
          
        VStack(spacing: 15) {
          CustomTextField(placeholder: "Name", isBold: false, height: 0.6, text: $avm.name)
          CustomTextField(placeholder: "Email", isBold: false, height: 0.6, text: $avm.email)
          CustomTextField(placeholder: "Address", isBold: false, height: 0.6, text: $avm.address)
          CustomTextField(placeholder: "Phone", isBold: false, height: 0.6, text: $avm.phone)
            .onChange(of: avm.phone) { oldValue, newValue in
              avm.phone = avm.formatNumberPhone(with: newValue)
            }
        }
        .padding(.vertical, 15)
        
        if let error = avm.errorMessage {
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
      CustomButton(text: "Save", color: avm.isValid ? .accent : .appLightGray) {
        Task { await avm.saveFromData()}
        router.dismissScreen()
      }
      .disabled(!avm.isValid)
      .padding(.horizontal, 48)
    }
  }
}

#Preview {
  EditInfoView(avm: AuthViewModel())
    .previewRouter()
}
