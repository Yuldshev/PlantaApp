import SwiftUI

struct DebitCard: View {
  @EnvironmentObject var vm: OrderViewModel
  @Environment(\.router) var router
  @Binding var selectedTab: Tab
  let price: Double
  
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
        CheckoutPriceRow(title: "Subtotal", value: price.asCurrency)
        CheckoutPriceRow(title: "Delivery Fee", value: (vm.deliveryMethod == .fast ? 30 : 18).asCurrency)
        CheckoutPriceRow(title: "Total", value: (price + (vm.deliveryMethod == .fast ? 30 : 18)).asCurrency)
        .padding(.bottom, 8)
        
        CustomButton(text: "Continue", color: vm.cardFormIsValid ? .accent : .appLightGray) {
          if vm.paymentMethod == .creditCard {
            router.showBottomModal {
              ConfirmModal(title: "Confirm Checkout?", subtitle: "") {
                router.dismissModal()
                router.showScreen(.fullScreenCover) { _ in SuccessOrderView()}
              } onCancel: {
                router.dismissModal()
              }
            }
          } else {
            router.showScreen(.push) { _ in SuccessOrderView() }
          }
        }
        .disabled(!vm.cardFormIsValid)
      }
      .padding(.top)
      .body(type: .regular)
      .padding(.horizontal, 24)
      .background(.white)
      .onAppear { vm.loadEmailFromCache() }
    }
  }
  
  private var BankInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Bank Information")
          .sub(type: .bold)
        CustomDivider(height: 1.5)
      }
      
      VStack(alignment: .leading, spacing: 15) {
        ForEach(CreditCard.allCases, id: \.rawValue) { type in
          VStack(spacing: 4) {
            TextField(type.rawValue.uppercased(), text: Binding(
              get: { vm.creditCardData[type] ?? ""},
              set: { vm.creditCardData[type] = $0 }
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
      
      VStack(alignment: .leading, spacing: 15) {
        ForEach(InfoType.allCases, id: \.rawValue) { type in
          VStack(spacing: 4) {
            Text("\(vm.info[type] ?? "0")")
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
      .overlay(alignment: .topTrailing) {
        Button { router.dismissScreen() } label: {
          Text("edit")
            .foregroundStyle(.black)
            .body(type: .regular)
        }
      }
      
      VStack(alignment: .leading, spacing: 15) {
        if vm.deliveryMethod == .fast {
          DeliveryMethodPicker(
            title: "Quick Shipping - $30",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.fast.formattedDate)",
            isCheck: vm.deliveryMethod == .standard
          ) {
            vm.deliveryMethod = .fast
          }
        } else {
          DeliveryMethodPicker(
            title: "COD - $18",
            subTitle: "Expected Shipping Date: \(DeliveryMethod.standard.formattedDate)",
            isCheck: vm.deliveryMethod == .fast
          ) {
            vm.deliveryMethod = .standard
          }
        }
      }
      .padding(.top, 15)
    }
  }
}

#Preview {
  DebitCard(selectedTab: .constant(.home), price: 300)
    .previewRouter()
    .environmentObject(OrderViewModel())
}
