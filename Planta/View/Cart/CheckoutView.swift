import SwiftUI

struct CheckoutView: View {
  @Environment(\.router) var router
  @StateObject var vm = OrderViewModel()
  let price: Double
  
  @State private var isValidate = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        PersonalInfo
        DeliveryMethodView
        PaymentMethodView
      }
      .padding(.horizontal, 48)
    }
    .inlineNavigation(title: "Checkout", isShow: false)
    .overlay(alignment: .bottom) {
      VStack(alignment: .leading, spacing: 8) {
        CheckoutPriceRow(title: "Subtotal", value: price.asCurrency)
        CheckoutPriceRow(title: "Delivery Fee", value: (vm.deliveryMethod == .fast ? 30 : 18).asCurrency)
        CheckoutPriceRow(title: "Total", value: (price + (vm.deliveryMethod == .fast ? 30 : 18)).asCurrency)
        .padding(.bottom, 8)
        
        CustomButton(text: "Continue", color: vm.formIsValid ? .accent : .appLightGray) {
          if vm.paymentMethod == .creditCard {
            router.showScreen(.push) { _ in DebitCard() }
          }
        }
        .disabled(!vm.formIsValid)
      }
      .padding(.top)
      .body(type: .regular)
      .padding(.horizontal, 24)
      .background(.white)
      .onAppear { vm.loadEmailFromCache() }
    }
  }
  
  private var PersonalInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Personal Information")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      
      VStack(alignment: .leading, spacing: 15) {
        ForEach(InfoType.allCases, id: \.rawValue) { type in
          VStack(spacing: 4) {
            TextField(type.rawValue.capitalized, text: Binding(
              get: { vm.info[type] ?? ""},
              set: { vm.info[type] = $0 }
            ))
            CustomDivider(color: .appLightGray, height: 0.55)
          }
        }
      }
      .body(type: .regular)
      .padding(.top, 15)
    }
    .padding(.vertical, 20)
  }
  
  private var DeliveryMethodView: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Delivery Method")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      
      VStack(alignment: .leading, spacing: 15) {
        DeliveryMethodPicker(
          title: "Quick Shipping - $15",
          subTitle: "Expected Shipping Date: \(DeliveryMethod.fast.formattedDate)",
          isCheck: vm.deliveryMethod == .fast
        ) {
          vm.deliveryMethod = .fast
        }
        
        DeliveryMethodPicker(
          title: "COD - $20",
          subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
          isCheck: vm.deliveryMethod == .standard
        ) {
          vm.deliveryMethod = .standard
        }
      }
      .padding(.top, 15)
    }
  }
  
  private var PaymentMethodView: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Payment Method")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      
      VStack(alignment: .leading) {
        ForEach(PaymentMethod.allCases, id: \.rawValue) { type in
          Button { vm.paymentMethod = type } label: {
            HStack {
              Text(type.rawValue.capitalized)
                .sub(type: .regular)
                .foregroundStyle(vm.paymentMethod == type ? .accent : .black)
              Spacer()
              
              if vm.paymentMethod == type {
                Image(.check)
                  .foregroundStyle(.accent)
              }
            }
            .frame(height: 32)
          }
        }
      }
      .padding(.top, 15)
    }
    .padding(.vertical, 20)
  }
}

struct CheckoutPriceRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(value)
    }
  }
}

#Preview {
  CheckoutView(price: 300)
    .previewRouter()
}
