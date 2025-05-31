import SwiftUI

struct CategorySelectorView: View {
  @Binding var selected: CategoryList
  @Namespace private var animation
  
  var body: some View {
    HStack {
      ForEach(CategoryList.allCases, id: \.self) { category in
        Button {
          withAnimation(.easeInOut(duration: 0.35)) {
            selected = category
          }
        } label: {
          ZStack {
            if selected == category {
              RoundedRectangle(cornerRadius: 8)
                .fill(.accent)
                .matchedGeometryEffect(id: category.rawValue, in: animation)
            }
            
            Text(category.rawValue.capitalized)
              .sub(type: .regular)
              .foregroundStyle(selected == category ? .white : .black)
              .padding(.vertical, 8)
              .padding(.horizontal, 16)
          }
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(.top, 20)
  }
}

