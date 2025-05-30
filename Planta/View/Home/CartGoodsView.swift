import SwiftUI

struct CartGoodsView: View {
  let item: Goods
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Rectangle()
        .fill(.appLight)
        .frame(width: 155, height: 134)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          Image(item.image)
            .resizable()
            .scaledToFit()
        }
      
      Text(item.name.capitalized)
        .sub(type: .bold)
        .padding(.top, 4)
        .minimumScaleFactor(0.8)
        .lineLimit(0)
        .multilineTextAlignment(.leading)
        .frame(width: 155, alignment: .leading)
      Text(item.category.rawValue.capitalized)
        .body(type: .regular)
        .foregroundStyle(.appLightGray)
      Text(item.price.asCurrency)
        .sub(type: .bold)
        .foregroundStyle(.accent)
    }
  }
}

