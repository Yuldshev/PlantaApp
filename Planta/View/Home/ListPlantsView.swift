import SwiftUI

struct ListPlantsView: View {
  @Environment(\.router) var router
  @State private var selectCategory: CategoryList = .all
  
  private var filteredGoods: [Goods] {
    selectCategory.filteredGoods
  }
  
  private let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20) {
        CategorySelectorView(selected: $selectCategory)
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(filteredGoods) { cart in
            Button {
              router.showScreen(.push) { _ in DetailsView(item: cart)}
            } label: {
              CartGoodsView(item: cart)
                .transition(.opacity.combined(with: .scale))
            }
          }
        }
        .animation(.easeInOut(duration: 0.4), value: selectCategory)
        .padding(.vertical, 20)
      }
      .padding(.horizontal, 20)
    }
    .inlineNavigation(title: "Plants")
  }
}

//MARK: - CategoryList
enum CategoryList: String, CaseIterable, Identifiable {
  case all, outdoor, indoor
  
  var id: String { rawValue }
  
  var title: String {
    rawValue.capitalized
  }
  
  var filteredGoods: [Goods] {
    switch self {
      case .all: return outdoorList + indoorList
      case .indoor: return indoorList
      case .outdoor: return outdoorList
    }
  }
}

#Preview {
  ListPlantsView()
    .previewRouter()
}
