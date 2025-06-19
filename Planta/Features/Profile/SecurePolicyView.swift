import SwiftUI

struct SecurePolicyView: View {
  var title = [
    ("1. Data Storage", "All personal data is stored in encrypted form. We use secure servers that meet industry security standards."),
    ("2. Payments", "All payments are processed through certified and secure payment gateways (such as Payme, Stripe, or similar). We do not store any credit card information on our servers."),
    ("3. Account Protection", "Login is protected via phone number verification and one-time password (OTP). Two-factor authentication (2FA) may be introduced in future updates."),
    ("4. Third Parties", "We do not sell or share your personal data with third-party companies. Contractors who assist with delivery or customer support may access only the minimum data necessary to perform their tasks.")
  ]
  
  var body: some View {
    ScrollView {
      VStack {
        VStack(alignment: .leading, spacing: 8) {
          Text("Security Policy")
            .sub(type: .bold)
          Text("At Planta, we prioritize the protection of your personal information and transactions.")
            .sub(type: .regular)
        }
        .padding(.vertical, 15)
        
        VStack(alignment: .leading, spacing: 15.0) {
          ForEach(Array(title.enumerated()), id: \.offset) { index, title in
            VStack(alignment: .leading, spacing: 15.0) {
              Text(title.0)
                .sub(type: .bold)
              Text(title.1)
                .sub(type: .regular)
            }
          }
        }
      }
      .padding(.horizontal, 48)
      .inlineNavigation(title: "Security Policy", isShow: false)
      .swipeBackGesture()
    }
  }
}

#Preview {
  SecurePolicyView()
    .previewRouter()
}
