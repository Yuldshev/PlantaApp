import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
  private var service: DataServiceProtocol
  
  @Published var query: String = ""
  @Published private(set) var filterGoods: [Goods] = []
  @Published private(set) var recentSearches: [String] = [] {
    didSet { Task { await saveRecentSearches() } }
  }
  
  private var allGoods: [Goods]
  private var maxRecentSearches = 5
  private var cancellables = Set<AnyCancellable>()
  
  init(allGoods: [Goods], service: DataServiceProtocol = DataService()) {
    self.allGoods = allGoods
    self.service = service
    setupSearch()
    
    Task { await loadRecentSearches() }
  }
  
  private func setupSearch() {
    $query
      .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] text in
        self?.performSearch(with: text)
      }
      .store(in: &cancellables)
  }
  
  private func performSearch(with text: String) {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmed.isEmpty else {
      filterGoods = []
      return
    }
    
    filterGoods = allGoods.filter {
      $0.name.lowercased().contains(trimmed.lowercased())
    }
    
    updateRecentSearches(with: trimmed)
  }
  
  private func updateRecentSearches(with query: String) {
    guard !query.isEmpty else { return }
    
    recentSearches.removeAll { $0.lowercased() == query.lowercased()}
    recentSearches.insert(query, at: 0)
    
    if recentSearches.count > maxRecentSearches {
      recentSearches = Array(recentSearches.prefix(maxRecentSearches))
    }
  }
  
  func clearRecentSearches() {
    recentSearches.removeAll()
  }
  
  private func saveRecentSearches() async {
    await service.saveCache(recentSearches, key: .recentSearch)
  }
  
  private func loadRecentSearches() async {
    if let cached: [String] = await service.loadCache(key: .recentSearch, as: [String].self) {
      recentSearches = cached
    } else {
      recentSearches = []
    }
  }
}
