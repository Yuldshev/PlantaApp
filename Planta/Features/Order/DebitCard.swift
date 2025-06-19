import SwiftUI

struct DebitCard: View {
  @ObservedObject var authVM: AuthViewModel
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var orderVM: OrderViewModel
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        BankInfo
        if authVM.isValid {
          PersonalInfo
        }
        DeliveryMethodView
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
        
        CustomButton(text: "Continue", color: orderVM.isValid ? .accent : .appLightGray) {
          router.showScreen(.fullScreenCover) { _ in SuccessOrderView(cartVM: cartVM, orderVM: orderVM) }
        }
        .disabled(!orderVM.isValid)
      }
      .padding(.top)
      .body(type: .regular)
      .padding(.horizontal, 24)
      .background(.white)
    }
  }
  
  //MARK: - BankInfo
  private var BankInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Bank Information")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      
      VStack(alignment: .leading, spacing: 15) {
        CustomTextField(placeholder: "Number Card", isBold: false, height: 0.6, text: $orderVM.pin)
          .onChange(of: orderVM.pin) { _, newValue in
            let formatted = newValue.formattedPin()
            if formatted != newValue {
              orderVM.pin = formatted
            }
          }
        CustomTextField(placeholder: "Card Name", isBold: false, height: 0.6, text: $orderVM.cardName)
        Button {
          router.showBasicModal { ExpirationDatePicker(vm: orderVM) }
        } label: {
          Text("expiration date".capitalized)
            .body(type: .regular)
        }
        CustomTextField(placeholder: "CVV", isBold: false, height: 0.6, text: $orderVM.cvc)
      }
      .body(type: .regular)
      .padding(.top, 15)
    }
    .padding(.vertical, 20)
  }
  
  //MARK: - PersonalInfo
  private var PersonalInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Personal Information")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      .overlay(alignment: .topTrailing) {
        Button { router.dismissScreen() } label: {
          Text("edit")
            .foregroundStyle(.black)
            .body(type: .regular)
        }
      }
      
      VStack(alignment: .leading) {
        PersonalInfoRow(title: "Name:", data: authVM.name)
        PersonalInfoRow(title: "Email:", data: authVM.email)
        PersonalInfoRow(title: "Address:", data: authVM.address)
        PersonalInfoRow(title: "Phone:", data: authVM.phone)
      }
      .padding(.top, 15)
    }
    .padding(.vertical, 20)
  }
  
  //MARK: - Delivery Method
  private var DeliveryMethodView: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Delivery Method")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      .overlay(alignment: .topTrailing) {
        Button { router.dismissScreen() } label: {
          Text("edit")
            .foregroundStyle(.black)
            .body(type: .regular)
        }
      }
      
      VStack(alignment: .leading, spacing: 15) {
        if orderVM.deliveryMethod == .fast {
          DeliveryMethodPicker(
            title: "Quick Shipping - $30",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.fast.formattedDate)",
            isCheck: orderVM.deliveryMethod == .standard
          ) {
            orderVM.deliveryMethod = .fast
          }
        } else {
          DeliveryMethodPicker(
            title: "COD - $18",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
            isCheck: orderVM.deliveryMethod == .fast
          ) {
            orderVM.deliveryMethod = .standard
          }
        }
      }
      .padding(.top, 15)
    }
  }
}

//MARK: - PersonalInfoRow
struct PersonalInfoRow: View {
  let title: String
  let data: String
  
  var body: some View {
    HStack {
      Text(title)
        .body(type: .bold)
      Text(data)
        .body(type: .regular)
    }
  }
}

#Preview {
  DebitCard(authVM: AuthViewModel(), cartVM: CartViewModel(), orderVM: OrderViewModel())
    .previewRouter()
}
