import SwiftUI

struct CartView: View {
  @ObservedObject var vm: MainViewModel
  @State private var isClear = false
  @Environment(\.router) var router
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20.0) {
        ForEach(vm.cartVM.items, id: \.goods.id) { item in
          CartListView(vm: vm.cartVM, item: item)
        }
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 20)
    .orderNavigation {
      Button {
        router.showBottomModal {
          ConfirmModal(title: "Delete all orders?", subtitle: "This cannot be undone", onConfirm: {
            vm.cartVM.clear()
          }, onCancel: { router.dismissModal() })
        }
      } label: {
        Image(vm.cartVM.items.isEmpty ? .trashOff: .trashOn)
          .foregroundStyle(.black)
      }
      .disabled(vm.cartVM.items.isEmpty)
    }
    .task { await vm.cartVM.loadCart() }
    .overlay(alignment: .bottom) {
      VStack {
        HStack {
          Text("Subtotal")
          Spacer()
          Text(vm.cartVM.totalPrice.formattedNumber)
        }
        .body(type: .regular)
        
        CustomButton(text: "Proceed to Checkout") {
          router.showScreen(.push) { _ in CheckoutView(vm: vm) }
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 80)
    }
  }
}

#Preview {
  let mainVM = MainViewModel()
  mainVM.cartVM.items = [
    Cart(goods: Goods(name: "Dracaena reflexa", category: .outdoor, image: "outdoor-1", price: 150.0), quantity: 1)
  ]
  
  return CartView(vm: mainVM)
    .previewRouter()
}
