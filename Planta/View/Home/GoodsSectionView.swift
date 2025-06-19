import SwiftUI

struct GoodsSectionView<Destination: View>: View {
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var mainVM: MainViewModel
  @Environment(\.router) var router
  
  let title: String
  let items: [Goods]
  let limit: Int?
  let destination: () -> Destination
  
  private let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .h1()
        .foregroundStyle(.black)
        
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(limitedItems) { item in
          Button {
            router.showScreen(.push) { _ in
              DetailsView(item: item, cartVM: cartVM, mainVM: mainVM)
            }
          } label: {
            CartGoodsView(item: item)
          }
        }
      }
      
      Button { destinationRoute() } label: {
        Text("See More")
          .sub(type: .bold)
          .foregroundStyle(.black)
          .underline()
      }
      .padding(.top, 24)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding(.vertical, 24)
  }
  
  private var limitedItems: [Goods] {
    limit.map { Array(items.prefix($0)) } ?? items
  }
  
  private func destinationRoute() {
    router.showScreen(.push) { _ in destination() }
  }
}
