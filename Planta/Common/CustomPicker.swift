import SwiftUI

struct CustomPicker: View {
  @EnvironmentObject var vm: OrderViewModel
  let item: Goods
  
  var body: some View {
    VStack {
      Text("You picked \(vm.items[item] ?? 0) item")
        .body(type: .regular)
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
