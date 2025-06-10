import SwiftUI

struct SearchView: View {
  @StateObject private var vm = SearchViewModel(allGoods: outdoorList + indoorList + equipmentList)
  let columns = [
    GridItem(.flexible(), spacing: 30),
    GridItem(.flexible(), spacing: 30)
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        SearchBar
        RecentSearches
      }
      .padding(.horizontal, 48)
    }
    .inlineNavigation(title: "Search", isShow: false)
  }
  
  private var SearchBar: some View {
    VStack {
      CustomTextField(placeholder: "Search...", text: $vm.query)
        .overlay(alignment: .trailing) {
          Image(vm.query.isEmpty ? .search : .quit)
            .offset(y: -4)
            .onTapGesture {
              if !vm.query.isEmpty {
                vm.query.removeAll()
              }
            }
        }
    }
    .padding(.vertical, 15)
  }
  
  private var RecentSearches: some View {
    VStack(alignment: .leading, spacing: 15) {
      if vm.query.isEmpty {
        VStack(alignment: .leading, spacing: 15) {
          Text("Recent searches")
            .sub(type: .bold)
        }
        
        HStack(spacing: 15) {
          ForEach(vm.recentSearches, id: \.self) { query in
              Text(query)
                .sub(type: .regular)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(.appLight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture { vm.query = query}
          }
        }
      } else {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(vm.filterGoods) { item in
            CartGoodsView(item: item)
          }
        }
      }
    }
    .padding(.vertical, 15)
    .animation(.easeInOut, value: vm.query)
  }
}

#Preview {
  SearchView()
    .previewRouter()
}
