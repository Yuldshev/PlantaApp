import SwiftUI

struct TransactionHistory: View {
  @ObservedObject var orderVM: OrderViewModel
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(orderVM.orders, id: \.date) { order in
          OrderCardView(order: order)
        }
      }
      .padding(.horizontal, 48)
      .task { await orderVM.loadOrders() }
      .inlineNavigation(title: "Transaction history", isShow: false)
    }
  }
}

struct OrderCardView: View {
  var order: Order
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 4) {
        Text(order.date.formattedWithOrdinalSuffix())
          .sub(type: .bold)
        CustomDivider(color: .appLightGray, height: 0.6)
      }
      
      HStack(spacing: 15) {
        Image(order.goods.first?.goods.image ?? "")
          .resizable()
          .scaledToFill()
          .frame(width: 77, height: 77)
          .background(.appLight)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        
        VStack(alignment: .leading, spacing: 2) {
          Text("Order Successful")
            .sub(type: .bold)
            .foregroundStyle(.accent)
          
          Text("\(order.goods.first?.goods.name ?? "No goods") | \(order.goods.first?.goods.category.rawValue.capitalized ?? "")")
            .body(type: .regular)
          
          Text("\(order.goods.count) item")
            .body(type: .regular)
            .foregroundStyle(.appLightGray)
          
          
        }
      }
    }
    .padding(.vertical, 15)
  }
}

#Preview {
  TransactionHistory(orderVM: OrderViewModel())
    .previewRouter()
}
