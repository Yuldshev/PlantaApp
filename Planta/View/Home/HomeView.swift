import SwiftUI

struct HomeView: View {
  @ObservedObject var vm: MainViewModel
  @Environment(\.router) var router

  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        Hero
        VStack {
          GoodsSectionView(vm: vm, title: "Plants", items: indoorList, limit: nil) {
            ListPlantsView(vm: vm) }
          
          GoodsSectionView(vm: vm, title: "Equipments", items: equipmentList, limit: 6) { ListEquipmentView(vm: vm) }
          BannerBalm
        }
        .padding(.horizontal, 24)
      }
    }
    .ignoresSafeArea(edges: .top)
  }
  
  private var Hero: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(.appLight)
        .frame(height: 62)
      
      Button {
        router.showScreen(.push) { _ in ListPlantsView(vm: vm) }
      } label: {
        HomeHiroView(vm: vm)
      }
    }
    .scrollTransition { content, phase in
      content
        .opacity(phase.isIdentity ? 1 : 0)
        .offset(y: phase.isIdentity ? 0 : -100)
    }
  }
  
  private var BannerBalm: some View {
    VStack(alignment: .leading) {
      Text("New")
        .h1()
      
      Button {
        router.showScreen(.push) { _ in
          ListEquipmentView(vm: vm)
        }
      } label: {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Lemon Balm Grow Kit ")
              .sub(type: .bold)
              .foregroundStyle(.black)
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
    }
    .padding(.vertical, 24)
    .padding(.bottom, 60)
  }
}

#Preview {
  HomeView(vm: MainViewModel())
    .previewRouter()
}
