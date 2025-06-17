import SwiftUI

struct CustomPicker: View {
  @Binding var quantity: Int
  let isTextHidden: Bool
  
  var body: some View {
    VStack {
      if isTextHidden {
        Text("You picked \(quantity) item")
          .body(type: .regular)
      }
      
      HStack(spacing: 24) {
        Button { quantity += 1 } label: {
          Image(.plusSquare)
            .foregroundStyle(.black)
        }
        
        Text("\(quantity)")
          .sub(type: .regular)
        
        Button {
          Task { quantity -= 1 }
        } label: {
          Image(.minusSquare)
            .foregroundStyle(.black)
        }
        .disabled(quantity <= 0)
      }
    }
  }
}
