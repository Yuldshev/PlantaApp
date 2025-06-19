import SwiftUI

struct CartView: View {
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var orderVM: OrderViewModel
  @ObservedObject var authVM: AuthViewModel
  @State private var isClear = false
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20.0) {
        if !cartVM.items.isEmpty {
          ForEach(cartVM.items, id: \.goods.id) { item in
            CartListView(cartVM: cartVM, item: item)
          }
        } else {
          emptyCartView
        }
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 20)
    .orderNavigation {
      Button {
        router.showBottomModal {
          ConfirmModal(title: "Delete all orders?", subtitle: "This cannot be undone", onConfirm: {
            cartVM.clear()
            router.dismissModal()
          }, onCancel: { router.dismissModal() })
        }
      } label: {
        Image(cartVM.items.isEmpty ? .trashOff: .trashOn)
          .foregroundStyle(.black)
      }
      .disabled(cartVM.items.isEmpty)
    }
    .task { await cartVM.loadCart() }
    .overlay(alignment: .bottom) {
      VStack {
        HStack {
          Text("Subtotal")
          Spacer()
          Text(cartVM.totalPrice.formattedNumber)
        }
        .body(type: .regular)
        
        CustomButton(text: "Proceed to Checkout") {
          router.showScreen(.push) { _ in CheckoutView(authVM: authVM, cartVM: cartVM, orderVM: orderVM) }
        }
      }
      .padding(.horizontal, 24)
      .padding(.top)
      .padding(.bottom, 80)
      .background(.white)
    }
  }
  
  private var emptyCartView: some View {
    VStack(spacing: 20) {
      Image(.emptyCart)
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
      
      VStack(spacing: 6) {
        Text("Your cart is empty")
          .sub(type: .bold)
        Text("Looks like you haven’t added anything yet. Start exploring and find something you love.")
          .body(type: .regular)
          .multilineTextAlignment(.center)
      }
      .foregroundStyle(.appLightGray)
    }
    .padding(.horizontal, 48)
    .padding(.top, 20)
  }
}

#Preview {
  CartView(cartVM: CartViewModel(), orderVM: OrderViewModel(), authVM: AuthViewModel())
    .previewRouter()
}
