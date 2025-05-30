import Foundation

struct Goods: Identifiable {
  var id = UUID()
  let name: String
  let category: GoodsCategory
  let image: String
  let price: Double
}

enum GoodsCategory: String, CaseIterable {
  case outdoor, indoor, equipment
}

let outdoorList: [Goods] = [
  //Outdoor
  Goods(name: "Dracaena reflexa", category: .outdoor, image: "outdoor-1", price: 150),
  Goods(name: "Rubber plant", category: .outdoor, image: "outdoor-2", price: 120),
  Goods(name: "Banana palm", category: .outdoor, image: "outdoor-3", price: 180),
  Goods(name: "Cycas revoluta", category: .outdoor, image: "outdoor-4", price: 150)
]

let indoorList: [Goods] = [
  Goods(name: "Chlorophytum", category: .indoor, image: "indoor-1", price: 90),
  Goods(name: "Anthurium andreanum", category: .indoor, image: "indoor-2", price: 120),
  Goods(name: "Anturio", category: .indoor, image: "indoor-3", price: 160),
  Goods(name: "Epipremnum", category: .indoor, image: "indoor-4", price: 140),
  Goods(name: "Zamioculcas", category: .indoor, image: "indoor-5", price: 120),
  Goods(name: "Areca catechu", category: .indoor, image: "indoor-6", price: 180)
]

let equipmentList: [Goods] = [
  Goods(name: "Planta Lemon Balm", category: .equipment, image: "equp-1", price: 60),
  Goods(name: "Planta Lime Balm", category: .equipment, image: "equp-2", price: 60),
  Goods(name: "Planta Rosewood", category: .equipment, image: "equp-3", price: 60),
  Goods(name: "Planta Dove Grey", category: .equipment, image: "equp-4", price: 60),
  Goods(name: "CB2 SAIC", category: .equipment, image: "equp-5", price: 90),
  Goods(name: "Xiaoda", category: .equipment, image: "equp-6", price: 120),
  Goods(name: "Shovels", category: .equipment, image: "equp-7", price: 80),
  Goods(name: "Finn Terrazzo", category: .equipment, image: "equp-9", price: 40),
  Goods(name: "Planta Den", category: .equipment, image: "equp-10", price: 60),
  Goods(name: "Small Sierra", category: .equipment, image: "equp-11", price: 90),
  Goods(name: "Big Sierra", category: .equipment, image: "equp-12", price: 140)
]
