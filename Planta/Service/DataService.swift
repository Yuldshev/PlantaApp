import Foundation

protocol DataServiceProtocol {
  func saveCache<T: Encodable>(_ data: T, key: CacheKey) async
  func loadCache<T: Decodable>(key: CacheKey, as type: T.Type) async -> T?
  func removeCache(for key: CacheKey)
  func clearAllCache()
}

final class DataService: DataServiceProtocol {
  private let userDefaults = UserDefaults.standard
  private let namespace = "AppCache"
  
  func saveCache<T>(_ data: T, key: CacheKey) where T : Encodable {
    let fullkey = namespaced(key)
    
    do {
      let encoded = try JSONEncoder().encode(data)
      userDefaults.set(encoded, forKey: fullkey)
    } catch {
      print("Error saving data: \(error)")
    }
  }
  
  func loadCache<T>(key: CacheKey, as type: T.Type) -> T? where T : Decodable {
    let fullkey = namespaced(key)
    guard let data = userDefaults.data(forKey: fullkey) else { return nil }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print("Error loading data: \(error)")
      return nil
    }
  }
  
  func removeCache(for key: CacheKey) {
    userDefaults.removeObject(forKey: namespaced(key))
  }
  
  func clearAllCache() {
    userDefaults.dictionaryRepresentation().keys
      .filter { $0.hasPrefix(namespace) }
      .forEach { userDefaults.removeObject(forKey: $0) }
  }
  
  private func namespaced(_ key: CacheKey) -> String {
    return namespace + key.rawValue
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
