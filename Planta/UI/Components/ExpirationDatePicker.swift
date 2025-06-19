import SwiftUI

struct ExpirationDatePicker: View {
  @ObservedObject var vm: OrderViewModel
  
  private var months: [Int] { Array(1...12) }
  private var years: [Int] {
    let currentYear = Calendar.current.component(.year, from: Date())
    return Array(currentYear...(currentYear + 5))
  }
  
  var body: some View {
    HStack {
      Picker("Month", selection: $vm.selectedMonth) {
        ForEach(months, id: \.self) {
          Text(String(format: "%02d", $0))
        }
      }
      .pickerStyle(InlinePickerStyle())
      .frame(maxWidth: .infinity)
      
      Picker("Year", selection: $vm.selectedYear) {
        ForEach(years, id: \.self) {
          Text(String($0))
        }
      }
      .pickerStyle(InlinePickerStyle())
      .frame(maxWidth: .infinity)
    }
    .padding()
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  ExpirationDatePicker(vm: OrderViewModel())
    .frame(maxHeight: .infinity)
    .background(.red)
}
