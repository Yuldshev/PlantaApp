import SwiftUI

struct HomeHiroView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text("Planta - shining your little space")
        .h1()
        .multilineTextAlignment(.leading)
        .foregroundStyle(.black)
        .frame(width: 225, height: 77)
        .lineSpacing(13)
        .padding(.top, 30)
      
      HStack(alignment: .center, spacing: 4.0) {
        Text("See New Arrivals")
          .sub(type: .bold)
          .foregroundStyle(.accent)
        Image(.arrowRight)
          .foregroundStyle(.accent)
      }
      Spacer()
    }
    .padding(.horizontal, 25)
    .frame(maxWidth: .infinity, alignment: .leading)
    .frame(height: 280)
    .background(.appLight)
    .overlay(alignment: .topTrailing) {
      Button(action: {}) {
        Image(.cart)
          .foregroundStyle(.black)
          .padding(18)
          .background(.white)
          .clipShape(Circle())
          .padding(25)
      }
    }
    .overlay(alignment: .bottomTrailing) {
      Image(.appBg2)
        .resizable()
        .scaledToFit()
    }
  }
}

#Preview {
    HomeHiroView()
}
