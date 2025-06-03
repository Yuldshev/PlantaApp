import SwiftUI

struct CustomPicker: View {
  @EnvironmentObject var vm: CartViewModel
  let item: Goods
  let isTextHidden: Bool
  
  var body: some View {
    VStack {
      if isTextHidden {
        Text("You picked \(vm.items[item] ?? 0) item")
          .body(type: .regular)
      }
      
      HStack(spacing: 24) {
        Button { vm.add(item) } label: {
          Image(.plusSquare)
            .foregroundStyle(.black)
        }
        
        Text("\(vm.items[item] ?? 0)")
          .sub(type: .regular)
        
        Button {
          vm.remove(item)
        } label: {
          Image(.minusSquare)
            .foregroundStyle(.black)
        }
      }
    }
  }
}
