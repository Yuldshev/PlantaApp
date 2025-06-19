import Foundation

protocol ValidationServiceProtocol {
  func validateUser(email: String, name: String, address: String, phone: String) -> Result<Bool, ValidationError>
  func isValidEmail(_ email: String) -> Result<Bool, ValidationError>
  func validateCard(pin: String, cardName: String, cvc: String) -> Result<Bool, ValidationError>
}

final class ValidationService: ValidationServiceProtocol {
  func validateUser(email: String, name: String, address: String, phone: String) -> Result<Bool, ValidationError> {
    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmedEmail.isEmpty, !trimmedName.isEmpty, !trimmedAddress.isEmpty, !trimmedPhone.isEmpty else {
      return .failure(.emptyFields)
    }
    
    return .success(true)
  }
  
  func isValidEmail(_ email: String) -> Result<Bool, ValidationError> {
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    
    return isValid ? .success(true) : .failure(.invalidEmail)
  }
  
  func validateCard(pin: String, cardName: String, cvc: String) -> Result<Bool, ValidationError> {
    let cleanPin = pin.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    guard cleanPin.count == 16 else { return .failure(.invalidCard) }
    
    guard !cardName.trimmingCharacters(in: .whitespaces).isEmpty else { return .failure(.emptyCardName) }
    guard cvc.count == 3, Int(cvc) != nil else { return .failure(.invalidCVC) }
    return .success(true)
  }
}

enum ValidationError: LocalizedError {
  case emptyFields, invalidEmail, invalidCard, emptyCardName, invalidCVC
  
  var errorDescription: String? {
    switch self {
      case .emptyFields: return "All fields are required."
      case .invalidEmail: return "Please enter a valid email"
      case .invalidCard: return "Please input correct number of digits"
      case .emptyCardName: return "Card name is required."
      case .invalidCVC: return "CVC must contain 3 digits"
    }
  }
}
