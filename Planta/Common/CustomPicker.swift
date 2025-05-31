import SwiftUI

struct CustomPicker: View {
  @EnvironmentObject var vm: OrderViewModel
  
  var body: some View {
    VStack {
      Text("You picked \(vm.count) item")
        .body(type: .regular)
      HStack(spacing: 24) {
        Button { vm.count += 1 } label: {
          Image(.plusSquare)
            .foregroundStyle(.black)
        }
        
        Text(vm.count.description)
          .sub(type: .regular)
        
        Button {
          if vm.count > 0 {
            vm.count -= 1
          }
        } label: {
          Image(.minusSquare)
            .foregroundStyle(.black)
        }
      }
    }
  }
}
