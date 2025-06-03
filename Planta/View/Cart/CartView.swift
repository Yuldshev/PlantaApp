import SwiftUI

struct CartView: View {
  @Environment(\.router) var router
  @EnvironmentObject var vm: CartViewModel
  @State private var isClear = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(vm.orderedItems, id: \.items) { item, count in
          CartListView(item: item)
            .environmentObject(vm)
        }
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 20)
    .orderNavigation {
      Button {
        router.showBottomModal {
          ConfirmClearModal(onConfirm: {
            vm.clear()
            router.dismissModal()
          }, onCancel: { router.dismissModal() })
        }
      } label: {
        Image(vm.items.isEmpty ? .trashOff: .trashOn)
          .foregroundStyle(.black)
      }
      .disabled(vm.items.isEmpty)
    }
    .onAppear { vm.loadCart() }
    .overlay(alignment: .bottom) {
      VStack {
        HStack {
          Text("Subtotal")
          Spacer()
          Text(vm.totalPrice.asCurrency)
        }
        .body(type: .regular)
        
        CustomButton(text: "Proceed to Checkout") {
          
        }
      }
      .padding(.horizontal, 24)
    }
  }
}

#Preview {
  CartView()
    .previewRouter()
    .environmentObject(CartViewModel())
}
