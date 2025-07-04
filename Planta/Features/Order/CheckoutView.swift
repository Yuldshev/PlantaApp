import SwiftUI

struct CheckoutView: View {
  @ObservedObject var authVM: AuthViewModel
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var orderVM: OrderViewModel
  @Environment(\.router) var router
  
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
    .swipeBackGesture()
    .overlay(alignment: .bottom) {
      VStack(alignment: .leading, spacing: 8) {
        CheckoutPriceRow(title: "Subtotal", value: cartVM.totalPrice.formattedNumber)
        CheckoutPriceRow(title: "Delivery Fee", value: (orderVM.deliveryMethod == .fast ? 30 : 18).formattedNumber)
        CheckoutPriceRow(title: "Total", value: (cartVM.totalPrice + (orderVM.deliveryMethod == .fast ? 30 : 18)).formattedNumber)
        .padding(.bottom, 8)
        
        CustomButton(text: "Continue", color: authVM.isValid ? .accent : .appLightGray) {
          if orderVM.paymentMethod == .creditCard {
            router.showScreen(.push) { _ in DebitCard(authVM: authVM, cartVM: cartVM, orderVM: orderVM) }
          } else {
            router.showScreen(.fullScreenCover) { _ in SuccessOrderView(cartVM: cartVM, orderVM: orderVM) }
          }
        }
        .disabled(!authVM.isValid)
      }
      .padding(.top)
      .body(type: .regular)
      .padding(.horizontal, 24)
      .background(.white)
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
        CustomTextField(placeholder: "Name", text: $authVM.name)
        CustomTextField(placeholder: "Email", text: $authVM.email)
        CustomTextField(placeholder: "Address", text: $authVM.address)
        CustomTextField(placeholder: "Phone", text: $authVM.phone)
          .onChange(of: authVM.phone) { oldValue, newValue in
            let formatted = newValue.formattedPhoneNumber()
            if formatted != newValue {
              authVM.phone = formatted
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
          title: "Quick Shipping - $30",
          subTitle: "Expected Shipping Date: \(DeliveryMethod.fast.formattedDate)",
          isCheck: orderVM.deliveryMethod == .fast
        ) {
          orderVM.deliveryMethod = .fast
        }
        
        DeliveryMethodPicker(
          title: "COD - $18",
          subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
          isCheck: orderVM.deliveryMethod == .standard
        ) {
          orderVM.deliveryMethod = .standard
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
          Button { orderVM.paymentMethod = type } label: {
            HStack {
              Text(type.rawValue.capitalized)
                .sub(type: .regular)
                .foregroundStyle(orderVM.paymentMethod == type ? .accent : .black)
              Spacer()
              
              if orderVM.paymentMethod == type {
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
  CheckoutView(authVM: AuthViewModel(), cartVM: CartViewModel(), orderVM: OrderViewModel())
    .previewRouter()
}
