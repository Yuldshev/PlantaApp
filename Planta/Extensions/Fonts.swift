import Foundation
import SwiftUI

enum Lato: String {
  case regular = "Lato-Regular"
  case bold = "Lato-Bold"
}

extension View {
  func h1() -> some View {
    self
      .font(Font.custom(Lato.bold.rawValue, size: 24))
  }
  
  func h3(type: Lato) -> some View {
    self
      .font(Font.custom(type.rawValue, size: 18))
  }
  
  func sub(type: Lato) -> some View {
    self
      .font(Font.custom(type.rawValue, size: 16))
  }
  
  func body(type: Lato) -> some View {
    self
      .font(Font.custom(type.rawValue, size: 14))
  }
  
  func customFont(type: Lato, size: CGFloat) -> some View {
    self
      .font(Font.custom(type.rawValue, size: size))
  }
}

