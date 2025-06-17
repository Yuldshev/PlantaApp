import Foundation

protocol ValidationServiceProtocol {
  func validateUser(email: String, name: String, address: String, phone: String) -> (isValid: Bool, error: String?)
  func validateCard(pin: String, cardName: String, cvc: String) -> (isFormValid: Bool, error: String?)
}

final class ValidationService: ValidationServiceProtocol {
  func validateUser(email: String, name: String, address: String, phone: String) -> (isValid: Bool, error: String?) {
    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let emailValid = isValidEmail(trimmedEmail)
    let allFieldsValid = !trimmedEmail.isEmpty && !trimmedName.isEmpty && !trimmedAddress.isEmpty && !trimmedPhone.isEmpty
    
    if !allFieldsValid {
      return (false, "All fields are required")
    } else if !emailValid {
      return (false, "Please enter a valid email")
    }
    
    return (true, nil)
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
  }
  
  func validateCard(pin: String, cardName: String, cvc: String) -> (isFormValid: Bool, error: String?) {
    let cleanPin = pin.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    guard cleanPin.count == 16 else { return (false, "Please input correct number of digits")}
    
    guard !cardName.trimmingCharacters(in: .whitespaces).isEmpty else { return (false, "Card name is required") }
    guard cvc.count == 3, Int(cvc) != nil else { return (false, "CVC must contain 3 digits") }
    return (true, nil)
  }
}
