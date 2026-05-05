//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation
import Combine

@MainActor
public class LoginViewModel: ObservableObject {
  @Published public var email = ""
  @Published public var password = ""
  @Published public var isLoading = false
  @Published public var errorMessage: String?
  @Published public var toast: Toast?
  
  public var isEmailValid: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
  public var isPasswordValid: Bool {
    return password.count >= 6
  }
  
  private let loginUseCase: LoginUseCase
  private let socialLoginUseCase: SocialLoginUseCase
  
  public init(loginUseCase: LoginUseCase, socialLoginUseCase: SocialLoginUseCase) {
    self.loginUseCase = loginUseCase
    self.socialLoginUseCase = socialLoginUseCase
  }
  
  public func login() {
    guard isEmailValid else {
      errorMessage = "Please enter a valid email address."
      return
    }
    
    guard isPasswordValid else {
      errorMessage = "Password must be at least 6 characters."
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    Task {
      do {
        _ = try await loginUseCase.execute(email: email, password: password)
        toast = Toast(message: "Login successful!", type: .success)
      } catch {
        if let authError = error as? AuthError {
          errorMessage = handleAuthError(authError)
        } else {
          errorMessage = error.localizedDescription
        }
      }
      isLoading = false
    }
  }
  
  public func loginWithGoogle() {
    isLoading = true
    errorMessage = nil
    
    Task {
      do {
        let tokens = try await GoogleSignInHelper.shared.signIn()
        _ = try await socialLoginUseCase.execute(provider: .google, idToken: tokens.idToken, accessToken: tokens.accessToken)
        toast = Toast(message: "Google login successful!", type: .success)
      } catch {
        errorMessage = "Google login failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
  
  public func loginWithApple() {
    isLoading = true
    errorMessage = nil
    
    Task {
      do {
        let tokens = try await AppleSignInHelper.shared.signIn()
        _ = try await socialLoginUseCase.execute(provider: .apple, idToken: tokens.rawNonce, accessToken: tokens.idToken)
        toast = Toast(message: "Apple login successful!", type: .success)
      } catch {
        errorMessage = "Apple login failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
  
  private func handleAuthError(_ error: AuthError) -> String {
    switch error {
    case .invalidCredentials: return "Invalid email or password."
    case .userNotFound: return "User not found."
    case .emailAlreadyInUse: return "Email is already in use."
    case .networkError: return "Network error. Please try again."
    case .socialLoginCancelled: return "Social login was cancelled."
    case .unknown: return "An unknown error occurred."
    case .custom(let message): return message
    }
  }
}
