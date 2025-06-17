import SwiftUI

struct DetailsView: View {
  let item: Goods
  @ObservedObject var vm: MainViewModel
  
  @State private var quantity = 0
  @Environment(\.router) var router
  
  let information = [
    ("Mass", "1kg"),
    ("Origin", "Africa"),
    ("Status", "250pcs")
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ImageItem
      
      VStack(alignment: .leading, spacing: 20) {
        CategoryText
        Price
        InfoItem
      }
      .padding(.horizontal, 48)
      
      Spacer()
      
      Order
    }
    .inlineNavigation(title: item.name, isShow: true)
  }
  
  private var ImageItem: some View {
    VStack {
      Rectangle()
        .fill(.appLight)
        .frame(height: 240)
        .overlay {
          Image(item.image)
            .resizable()
            .scaledToFit()
        }
    }
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
    Text(item.price.asCurrency)
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
        CustomPicker(quantity: $quantity, isTextHidden: true)
          .environmentObject(vm)
        
        Spacer()
        
        VStack {
          Text("Subtotal")
            .body(type: .regular)
          Text((item.price * Double(quantity)).asCurrency)
            .h1()
        }
      }
      
      CustomButton(text: "Order Now", color: quantity > 0 ? .accent : .appLightGray) {
        Task { await vm.cartVM.saveCart(item: item, quantity: quantity) }
        router.dismissPushStack()
        vm.tab = .order
      }
      .disabled(quantity < 1)
      
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  let goods = Goods(name: "Dracaena reflexa", category: .indoor, image: "outdoor-1", price: 150)
  
  return DetailsView(item: goods, vm: MainViewModel())
    .previewRouter()
}

