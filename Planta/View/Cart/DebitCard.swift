import SwiftUI

struct DebitCard: View {
  @ObservedObject var vm: MainViewModel
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        BankInfo
        PersonalInfo
        DeliveryMethodView
      }
      .padding(.horizontal, 48)
    }
    .inlineNavigation(title: "Checkout", isShow: false)
    .overlay(alignment: .bottom) {
      VStack(alignment: .leading, spacing: 8) {
        CheckoutPriceRow(title: "Subtotal", value: vm.cartVM.totalPrice.asCurrency)
        CheckoutPriceRow(title: "Delivery Fee", value: (vm.orderVM.deliveryMethod == .fast ? 30 : 18).asCurrency)
        CheckoutPriceRow(title: "Total", value: (vm.cartVM.totalPrice + (vm.orderVM.deliveryMethod == .fast ? 30 : 18)).asCurrency)
        .padding(.bottom, 8)
        
        CustomButton(text: "Continue", color: vm.orderVM.isFormValid ? .accent : .appLightGray) {
          Task { await vm.orderVM.saveData(user: User(email: vm.authVM.email, name: vm.authVM.name, address: vm.authVM.address, phone: vm.authVM.phone), goods: vm.cartVM.items) }
          vm.cartVM.clear()
          router.showScreen(.push) { _ in SuccessOrderView() }
        }
        .disabled(!vm.orderVM.isFormValid)
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
        CustomTextField(placeholder: "Number Card", isBold: false, height: 0.6, text: $vm.orderVM.pin)
        CustomTextField(placeholder: "Card Name", isBold: false, height: 0.6, text: $vm.orderVM.cardName)
        Button {
          router.showBasicModal { ExpirationDatePicker(vm: vm.orderVM) }
        } label: {
          Text("expiration date".capitalized)
            .body(type: .regular)
        }
        CustomTextField(placeholder: "CVV", isBold: false, height: 0.6, text: $vm.orderVM.cvc)
      }
      .body(type: .regular)
      .padding(.top, 15)
    }
    .padding(.vertical, 20)
    .onAppear { Task { await vm.orderVM.loadDebitCard() } }
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
        PersonalInfoRow(title: "Name:", data: vm.authVM.name)
        PersonalInfoRow(title: "Email:", data: vm.authVM.email)
        PersonalInfoRow(title: "Address:", data: vm.authVM.address)
        PersonalInfoRow(title: "Phone:", data: vm.authVM.phone)
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
        if vm.orderVM.deliveryMethod == .fast {
          DeliveryMethodPicker(
            title: "Quick Shipping - $30",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.fast.formattedDate)",
            isCheck: vm.orderVM.deliveryMethod == .standard
          ) {
            vm.orderVM.deliveryMethod = .fast
          }
        } else {
          DeliveryMethodPicker(
            title: "COD - $18",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
            isCheck: vm.orderVM.deliveryMethod == .fast
          ) {
            vm.orderVM.deliveryMethod = .standard
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
  DebitCard(vm: MainViewModel())
    .previewRouter()
}
