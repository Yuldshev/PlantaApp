import SwiftUI

struct SuccessOrderView: View {
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var orderVM: OrderViewModel
  @Environment(\.router) var router
  @State var isAnimation = false
  
  var body: some View {
    VStack(spacing: 20) {
      Image(.check)
        .resizable()
        .scaledToFit()
        .foregroundStyle(.white)
        .frame(width: 100, height: 100)
        .padding()
        .background(.accent)
        .clipShape(Circle())
        .scaleEffect(isAnimation ? 1 : 0)
        .opacity(isAnimation ? 1 : 0)
      
      Text("Order Successfully")
        .h1()
    }
    .inlineNavigation(title: "Success Order", isShow: false)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(alignment: .bottom) {
      CustomButton(text: "Back to Homepage") {
        Task {
          await orderVM.saveData(goods: cartVM.items)
          cartVM.clear()
          router.dismissPushStack()
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 20)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        withAnimation(.spring) {
          isAnimation = true
        }
      }
    }
  }
}

#Preview {
  SuccessOrderView(cartVM: CartViewModel(), orderVM: OrderViewModel())
    .previewRouter()
}
