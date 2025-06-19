import SwiftUI

struct DetailsView: View {
  let item: Goods
  @State private var quantity = 0
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var mainVM: MainViewModel
  @Environment(\.router) var router
  
  let information = [
    ("Mass", "1kg"),
    ("Origin", "Africa"),
    ("Status", "250pcs")
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      ImageItem
      
      VStack(alignment: .leading, spacing: 20) {
        CategoryText
        Price
        InfoItem
      }
      .padding(.horizontal, 48)
      
      Order
        .padding(.top, 110)
    }
    .inlineNavigation(title: item.name, isShow: true)
    .swipeBackGesture()
  }
  
  private var ImageItem: some View {
    VStack {
      Rectangle()
        .fill(.appLight)
        .overlay(alignment: .bottom) {
          Image(item.image)
            .resizable()
            .scaledToFit()
            .scrollTransition { content, phase in
              content
                .scaleEffect(phase.isIdentity ? 1 : 1.5)
                .offset(y: phase.isIdentity ? 0 : -80)
            }
        }
    }
    .frame(height: 240)
  }
  
  private var CategoryText: some View {
    HStack(spacing: 8) {
      if item.category.rawValue == "indoor" || item.category.rawValue == "outdoor" {
        Text("Plants")
          .body(type: .regular)
          .foregroundStyle(.white)
          .padding(.vertical, 6)
          .padding(.horizontal, 12)
          .background(.accent)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      Text(item.category.rawValue.capitalized)
        .body(type: .regular)
        .foregroundStyle(.white)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(.accent)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding(.top, 15)
  }
  
  private var Price: some View {
    Text(item.price.formattedNumber)
      .h1()
      .foregroundStyle(.accent)
  }
  
  private var InfoItem: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("Details")
        .sub(type: .bold)
      CustomDivider()
        .padding(.bottom, 20)
      
      VStack(spacing: 20) {
        ForEach(Array(information.enumerated()), id: \.offset) { index, info in
          HStack {
            Text(info.0)
            Spacer()
            Text(info.1)
          }
          .body(type: .regular)
        }
      }
      
    }
  }
  
  private var Order: some View {
    VStack {
      HStack {
        CustomPicker(item: item, quantity: $quantity, isTextHidden: false)
        
        Spacer()
        
        VStack {
          Text("Subtotal")
            .body(type: .regular)
          Text((item.price * Double(quantity)).formattedNumber)
            .h1()
        }
      }
      
      CustomButton(text: "Order Now", color: quantity > 0 ? .accent : .appLightGray) {
        Task {
          cartVM.updateQuantity(for: item, to: quantity)
          router.dismissPushStack()
          mainVM.tab = .order
        }
      }
      .disabled(quantity < 1)
      
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  let goods = Goods(name: "Dracaena reflexa", category: .indoor, image: "outdoor-1", price: 150)
  
  return DetailsView(item: goods, cartVM: CartViewModel(), mainVM: MainViewModel())
    .previewRouter()
}

