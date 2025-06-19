import SwiftUI

struct HomeView: View {
  @ObservedObject var cartVM: CartViewModel
  @ObservedObject var orderVM: OrderViewModel
  @ObservedObject var mainVM: MainViewModel
  @Environment(\.router) var router

  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        Hero
        VStack {
          GoodsSectionView(cartVM: cartVM, mainVM: mainVM, title: "Plants", items: indoorList, limit: nil) {
            ListPlantsView(cartVM: cartVM, mainVM: mainVM) }
          
          GoodsSectionView(cartVM: cartVM, mainVM: mainVM, title: "Equipments", items: equipmentList, limit: 6) { ListEquipmentView(cartVM: cartVM, mainVM: mainVM) }
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
        router.showScreen(.push) { _ in ListPlantsView(cartVM: cartVM, mainVM: mainVM) }
      } label: {
        HomeHiroView(mainVM: mainVM)
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
          ListEquipmentView(cartVM: cartVM, mainVM: mainVM)
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
  HomeView(cartVM: CartViewModel(), orderVM: OrderViewModel(), mainVM: MainViewModel())
    .previewRouter()
}
