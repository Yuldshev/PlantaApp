import SwiftUI

struct TermsPolicyView: View {
  var title = [
    ("1. General Terms", "Planta is a mobile application that offers the sale and delivery of indoor/outdoor plants, gardening tools, and accessories."),
    ("2. Orders & Delivery", "An order is considered confirmed once payment is completed. Order processing time: 1–3 business days. Delivery time depends on your region and selected shipping method. If you order multiple plants, they may be shipped separately."),
    ("3. Cancellation & Returns", "You may cancel your order within 12 hours after placement. Returns are accepted only if the product is damaged during delivery (photo or video evidence required). Live plants cannot be returned unless the issue is related to product quality."),
    ("4. User Data", "You agree to provide accurate contact information (full name, address, phone number) to ensure successful delivery. We do not share your data with third parties without your consent."),
    ("5. Updates", "We may update these terms from time to time. You will be notified of any changes via the app or email.")
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Welcome to Planta!")
            .sub(type: .bold)
          Text("By using our app, you agree to the terms outlined below. Please read them carefully.")
            .sub(type: .regular)
            .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 15)
        
        VStack(alignment: .leading, spacing: 15) {
          ForEach(Array(title.enumerated()), id: \.offset) { index, text in
            VStack(alignment: .leading, spacing: 15) {
              Text(text.0)
                .sub(type: .bold)
              Text(text.1)
                .sub(type: .regular)
                .multilineTextAlignment(.leading)
            }
          }
        }
      }
      .padding(.horizontal, 48)
      .inlineNavigation(title: "Terms & Policy", isShow: false)
    }
  }
}

#Preview {
  TermsPolicyView()
    .previewRouter()
}
