import SwiftUI

struct CartListView: View {
  @ObservedObject var cartVM: CartViewModel
  var item: Cart
  
  var body: some View {
    HStack(spacing: 15) {
      Image(item.goods.image)
        .resizable()
        .scaledToFit()
        .frame(width: 77, height: 77)
        .background(.appLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("\(item.goods.name) |")
            .sub(type: .bold)
          Text(item.goods.category.rawValue.capitalized)
            .body(type: .regular)
            .foregroundStyle(.appLightGray)
        }
        
        Text(item.goods.price.formattedNumber)
          .sub(type: .bold)
          .foregroundStyle(.accent)
        
        HStack {
          Text("Quantiy: \(item.quantity)")
            .body(type: .regular)
            .foregroundStyle(.appLightGray)
          
          Spacer()
          
          Button {  cartVM.remove(item.goods) } label: {
            Text("Remove")
              .sub(type: .regular)
              .foregroundStyle(.black)
              .underline()
          }
        }
      }
        
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
