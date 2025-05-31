import SwiftUI

struct OrderView: View {
  var body: some View {
    VStack {
      Text("OrderView")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.red)
  }
}

#Preview {
  OrderView()
}
