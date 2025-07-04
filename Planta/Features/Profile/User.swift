import Foundation

struct User: Codable, Equatable, Hashable {
  let email: String
  let name: String?
  let address: String?
  let phone: String?
}
