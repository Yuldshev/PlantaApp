import SwiftUI

struct EditInfoView: View {
  @State private var name = ""
  @State private var email = ""
  @State private var address = ""
  @State private var phone = ""
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 15) {
        Text("The information will be saved for the next purchase. Click on the details to edit.")
          .body(type: .regular)
          
        VStack(spacing: 15) {
          CustomTextField(placeholder: "Name", isBold: false, height: 0.6, text: $name)
          CustomTextField(placeholder: "Email", isBold: false, height: 0.6, text: $email)
          CustomTextField(placeholder: "Address", isBold: false, height: 0.6, text: $address)
          CustomTextField(placeholder: "Phone", isBold: false, height: 0.6, text: $phone)
        }
        .padding(.vertical, 15)
      }
      .padding(.vertical, 15)
      .padding(.horizontal, 48)
      .inlineNavigation(title: "Edit Information", isShow: false)
    }
    .overlay(alignment: .bottom) {
      CustomButton(text: "Save") {
        //TODO: - vm method
      }
      .padding(.horizontal, 48)
    }
  }
}

#Preview {
  EditInfoView()
    .previewRouter()
}
