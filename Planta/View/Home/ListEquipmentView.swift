import SwiftUI

struct ListEquipmentView: View {
  @ObservedObject var vm: MainViewModel
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
            router.showScreen(.push) { _ in DetailsView(item: item, vm: vm) }
          } label: {
            CartGoodsView(item: item)
          }
        }
      }
      .padding(20)
    }
    .inlineNavigation(title: "Equipments", isShow: true)
  }
}

#Preview {
  ListEquipmentView(vm: MainViewModel())
    .previewRouter()
}
