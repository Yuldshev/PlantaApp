import SwiftUI

struct HomeView: View {
  private let columns = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    
      
    
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          Rectangle()
            .fill(.appLight)
            .frame(height: 62)
          Button(action: {}) {
            HomeHiroView()
          }
        }
        .scrollTransition { content, phase in
          content
            .opacity(phase.isIdentity ? 1 : 0)
            .offset(y: phase.isIdentity ? 0 : -100)
        }
        
        VStack {
          PlantsView
          EquipmentsView
          BannerBalm
        }
        .padding(.horizontal, 24)
      }
    }
    .ignoresSafeArea(edges: .top)
  }
  
  private var PlantsView: some View {
    VStack(alignment: .leading) {
      Text("Plants")
        .h1()
        .padding(.top, 24)
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(indoorList) { item in
          CartGoodsView(item: item)
        }
      }
      Button(action: {}) {
        Text("See More")
          .sub(type: .bold)
          .foregroundStyle(.black)
          .underline()
      }
      .padding(.top, 16)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
  
  private var EquipmentsView: some View {
    VStack(alignment: .leading) {
      Text("Equipments")
        .h1()
        .padding(.top, 24)
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(equipmentList.prefix(6)) { item in
          CartGoodsView(item: item)
        }
      }
      Button(action: {}) {
        Text("See More")
          .sub(type: .bold)
          .foregroundStyle(.black)
          .underline()
      }
      .padding(.top, 16)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
  
  private var BannerBalm: some View {
    VStack(alignment: .leading) {
      Text("New")
        .h1()
      
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("Lemon Balm Grow Kit ")
            .sub(type: .bold)
          Text("Include: Lemon Balm seeds, dung, Planta pot, marker...")
            .body(type: .regular)
            .foregroundStyle(.appLightGray)
            .frame(width: 176)
        }
        
        Image(.appBg3)
          .resizable()
          .scaledToFit()
      }
      .padding(.leading, 24)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.appLight)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding(.vertical, 24)
  }
}



#Preview {
  HomeView()
}
