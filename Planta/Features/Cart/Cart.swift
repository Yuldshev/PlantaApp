import Foundation

struct Cart: Codable, Hashable {
  let goods: Goods
  var quantity: Int
}
