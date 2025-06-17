import SwiftUI

struct CheckoutView: View {
  @ObservedObject var vm: MainViewModel
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
    .overlay(alignment: .bottom) {
      VStack(alignment: .leading, spacing: 8) {
        CheckoutPriceRow(title: "Subtotal", value: vm.cartVM.totalPrice.formattedNumber)
        CheckoutPriceRow(title: "Delivery Fee", value: (vm.orderVM.deliveryMethod == .fast ? 30 : 18).formattedNumber)
        CheckoutPriceRow(title: "Total", value: (vm.cartVM.totalPrice + (vm.orderVM.deliveryMethod == .fast ? 30 : 18)).formattedNumber)
        .padding(.bottom, 8)
        
        CustomButton(text: "Continue") {
          if vm.orderVM.paymentMethod == .creditCard {
            router.showScreen(.push) { _ in DebitCard(vm: vm) }
          } else {
            Task { await vm.orderVM.saveData(user: User(email: "", name: "", address: "", phone: ""), goods: vm.cartVM.items) }
            router.showScreen(.push) { _ in SuccessOrderView(vm: vm) }
          }
        }
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
        CustomTextField(placeholder: "Name", text: $vm.authVM.name)
        CustomTextField(placeholder: "Email", text: $vm.authVM.email)
        CustomTextField(placeholder: "Address", text: $vm.authVM.address)
        CustomTextField(placeholder: "Phone", text: $vm.authVM.phone)
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
          isCheck: vm.orderVM.deliveryMethod == .fast
        ) {
          vm.orderVM.deliveryMethod = .fast
        }
        
        DeliveryMethodPicker(
          title: "COD - $18",
          subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
          isCheck: vm.orderVM.deliveryMethod == .standard
        ) {
          vm.orderVM.deliveryMethod = .standard
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
          Button { vm.orderVM.paymentMethod = type } label: {
            HStack {
              Text(type.rawValue.capitalized)
                .sub(type: .regular)
                .foregroundStyle(vm.orderVM.paymentMethod == type ? .accent : .black)
              Spacer()
              
              if vm.orderVM.paymentMethod == type {
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
  CheckoutView(vm: MainViewModel())
    .previewRouter()
}
