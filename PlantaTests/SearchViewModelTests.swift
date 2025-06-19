import XCTest
import Combine
@testable import Planta

actor MockDataService: DataServiceProtocol {
  private var store: [CacheKey: Data] = [:]
  
  func saveCache<T: Encodable>(_ data: T, key: CacheKey) async {
    store[key] = try? JSONEncoder().encode(data)
  }
  
  func loadCache<T>(key: CacheKey, as type: T.Type) async -> T? where T : Decodable {
    guard let data = store[key] else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
  }
  
  func removeCache(for key: CacheKey) async { store[key] = nil }
  func clearAllCache() async { store.removeAll() }
}

@MainActor
final class SearchViewModelTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()
  private let goods = [
    Goods(name: "Apple Tree",  category: .outdoor,   image: "", price: 10),
    Goods(name: "Banana Palm", category: .outdoor,   image: "", price: 20),
    Goods(name: "Chili Pepper",category: .equipment, image: "", price: 5)
  ]
  
  private func makeSUT() -> SearchViewModel {
    SearchViewModel(allGoods: goods, service: MockDataService())
  }
  
  func test_query_search_shouldFilterGoodsAndAddRecentSearch() async throws {
    let vm = makeSUT()
    let expectation = XCTestExpectation(description: "filterGoods updated")
    
    vm.$filterGoods
      .dropFirst()
      .sink { _ in expectation.fulfill() }
      .store(in: &cancellables)
    
    vm.query = "apple"
    
    await fulfillment(of: [expectation], timeout: 1.0)
    
    XCTAssertEqual(vm.filterGoods.map(\.name), ["Apple Tree"])
    XCTAssertEqual(vm.recentSearches.first, "apple")
  }
  
  func test_recentSearches_duplicatesAndLimit() async throws {
    let vm = makeSUT()
    
    for i in 0..<6 {
      vm.query = "q\(i)"
      try await Task.sleep(for: .milliseconds(700))
    }
    
    XCTAssertEqual(vm.recentSearches.count, 5)
    XCTAssertEqual(vm.recentSearches.first, "q5")
    
    vm.query = "q6"
    try await Task.sleep(for: .milliseconds(700))
    
    XCTAssertEqual(vm.recentSearches.count, 5)
    XCTAssertEqual(vm.recentSearches.first, "q6")
  }
  
  func test_clearRecentSearches_shouldEmptyArray() async throws {
    let vm = makeSUT()
    vm.query = "test"
    try await Task.sleep(for: .milliseconds(700))
    
    XCTAssertFalse(vm.recentSearches.isEmpty)
    vm.clearRecentSearches()
    XCTAssertTrue(vm.recentSearches.isEmpty)
  }
}
