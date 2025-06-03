import SwiftUI

struct DeliveryMethodPicker: View {
  let title: String
  let subTitle: String
  let isCheck: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .foregroundStyle(isCheck ? .accent: .black)

          Text(subTitle)
            .foregroundStyle(.appLightGray)
        }
        .body(type: .regular)
        
        Spacer()
        
        if isCheck {
          Image(.check)
        }
      }
    }
  }
}
