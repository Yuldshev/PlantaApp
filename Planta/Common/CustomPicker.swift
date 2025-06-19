import SwiftUI

struct CustomPicker: View {
  @ObservedObject var cartVM: CartViewModel
  let item: Goods
  let isTextHidden: Bool
  
  var body: some View {
    VStack {
      if isTextHidden {
        Text("You picked \(cartVM.totalCount) item")
          .body(type: .regular)
      }
      
      HStack(spacing: 24) {
        Button { cartVM.add(item) } label: {
          Image(.plusSquare)
            .foregroundStyle(.black)
        }
        
        Text("\(cartVM.totalCount)")
          .sub(type: .regular)
        
        Button {
          cartVM.remove(item)
        } label: {
          Image(.minusSquare)
            .foregroundStyle(.black)
        }
        .disabled(cartVM.totalCount <= 0)
      }
    }
  }
}
