import SwiftUI

struct ListEquipmentView: View {
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var mainVM: MainViewModel
  @Environment(\.router) var router
  
  private let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(equipmentList) { item in
          Button {
            router.showScreen(.push) { _ in DetailsView(item: item, cartVM: cartVM, mainVM: mainVM) }
          } label: {
            CartGoodsView(item: item)
          }
        }
      }
      .padding(20)
    }
    .inlineNavigation(title: "Equipments", isShow: true)
    .swipeBackGesture()
  }
}

#Preview {
  ListEquipmentView(cartVM: CartViewModel(), mainVM: MainViewModel())
    .previewRouter()
}
