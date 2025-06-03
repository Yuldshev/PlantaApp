import SwiftUI

struct CartListView: View {
  @EnvironmentObject var vm: CartViewModel
  var item: Goods
  
  var body: some View {
    HStack(spacing: 15) {
      Button {} label: {
        Image(.checkBoxOff)
          .foregroundStyle(.black)
      }
      
      Image(item.image)
        .resizable()
        .scaledToFit()
        .frame(width: 77, height: 77)
        .background(.appLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      VStack(alignment: .leading) {
        HStack {
          Text("\(item.name) |")
            .sub(type: .bold)
          Text(item.category.rawValue.capitalized)
            .body(type: .regular)
            .foregroundStyle(.appLightGray)
        }
        
        Text(item.price.asCurrency)
          .sub(type: .bold)
          .foregroundStyle(.accent)
        
        HStack(alignment: .bottom, spacing: 24) {
          CustomPicker(item: item, isTextHidden: false)
            .environmentObject(vm)
            .frame(width: 120)
          
          Button { vm.remove(item) } label: {
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
