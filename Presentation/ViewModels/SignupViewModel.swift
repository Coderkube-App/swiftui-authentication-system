//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation
import Combine

@MainActor
public class SignupViewModel: ObservableObject {
  @Published public var email = ""
  @Published public var password = ""
  @Published public var confirmPassword = ""
  @Published public var isLoading = false
  @Published public var errorMessage: String?
  @Published public var toast: Toast?
  @Published public var isSignupSuccessful = false
  
  public var isEmailValid: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
  public var isPasswordValid: Bool {
    return password.count >= 6
  }
  
  public var isConfirmPasswordValid: Bool {
    return password == confirmPassword
  }
  
  private let signupUseCase: SignupUseCase
  
  public init(signupUseCase: SignupUseCase) {
    self.signupUseCase = signupUseCase
  }
  
  public func signup() {
    guard isEmailValid else {
      errorMessage = "Please enter a valid email address."
      return
    }
    
    guard isPasswordValid else {
      errorMessage = "Password must be at least 6 characters."
      return
    }
    
    guard isConfirmPasswordValid else {
      errorMessage = "Passwords do not match."
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    Task {
      do {
        _ = try await signupUseCase.execute(email: email, password: password)
        toast = Toast(message: "Account created successfully!", type: .success)
        // Give time for toast to be seen before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          self.isSignupSuccessful = true
        }
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }
}
