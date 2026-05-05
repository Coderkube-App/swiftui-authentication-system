//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

public enum AuthError: Error, LocalizedError {
  case invalidCredentials
  case userNotFound
  case emailAlreadyInUse
  case networkError
  case socialLoginCancelled
  case unknown
  case custom(String)
  
  public var errorDescription: String? {
    switch self {
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

public protocol AuthRepositoryProtocol {
  func login(email: String, password: String) async throws -> AuthSession
  func signup(email: String, password: String) async throws -> AuthSession
  func socialLogin(provider: AuthProvider, idToken: String, accessToken: String?) async throws -> AuthSession
  func logout() async throws
  func getCurrentSession() -> AuthSession?
}
