import SwiftUI

struct ListEquipmentView: View {
  private let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(equipmentList) { item in
          CartGoodsView(item: item)
        }
      }
      .padding(20)
    }
    .inlineNavigation(title: "Equipments")
  }
}

#Preview {
  ListEquipmentView()
    .previewRouter()
}
