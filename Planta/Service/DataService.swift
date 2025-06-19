import Foundation

protocol DataServiceProtocol {
  func saveCache<T: Encodable>(_ data: T, key: CacheKey) async
  func loadCache<T: Decodable>(key: CacheKey, as type: T.Type) async -> T?
  func removeCache(for key: CacheKey) async
  func clearAllCache() async
}

actor DataService: DataServiceProtocol {
  private let userDefaults = UserDefaults.standard
  private let namespace = "AppCache"
  
  func saveCache<T: Encodable>(_ data: T, key: CacheKey) async {
    let fullKey = self.namespaced(key)
    
    do {
      let encoded = try JSONEncoder().encode(data)
      self.userDefaults.set(encoded, forKey: fullKey)
    } catch {
      return
    }
  }
  
  func loadCache<T: Decodable>(key: CacheKey, as type: T.Type) async -> T? {
    let fullkey = namespaced(key)
    guard let data = userDefaults.data(forKey: fullkey) else { return nil }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      return nil
    }
  }
  
  func removeCache(for key: CacheKey) async {
    userDefaults.removeObject(forKey: namespaced(key))
  }
  
  func clearAllCache() async {
    userDefaults.dictionaryRepresentation().keys
      .filter { $0.hasPrefix(namespace) }
      .forEach { userDefaults.removeObject(forKey: $0) }
  }
  
  private func namespaced(_ key: CacheKey) -> String {
    return "\(namespace).\(key.rawValue)"
  }
}

enum CacheKey: String {
  case user
  case cart
  case recentSearch
  case order
  
  var type: Any.Type {
    switch self {
      case .user: return User.self
      case .cart: return [Cart].self
      case .recentSearch: return [String].self
      case .order: return [Order].self
    }
  }
}
