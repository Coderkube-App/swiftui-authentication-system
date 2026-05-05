//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation
import FirebaseAuth

public protocol AuthRemoteDataSourceProtocol {
  func login(email: String, password: String) async throws -> AuthSession
  func signup(email: String, password: String) async throws -> AuthSession
  func socialLogin(provider: AuthProvider, idToken: String, accessToken: String?) async throws -> AuthSession
  func logout() async throws
}

public class FirebaseAuthDataSource: AuthRemoteDataSourceProtocol {
  public init() {}
  
  public func login(email: String, password: String) async throws -> AuthSession {
    do {
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      let token = try await result.user.getIDToken()
      
      let user = User(
        id: result.user.uid,
        email: result.user.email,
        displayName: result.user.displayName,
        provider: .email
      )
      return AuthSession(token: token, user: user)
    } catch {
      throw mapFirebaseError(error)
    }
  }
  
  public func signup(email: String, password: String) async throws -> AuthSession {
    do {
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      let token = try await result.user.getIDToken()
      
      let user = User(
        id: result.user.uid,
        email: result.user.email,
        displayName: result.user.displayName,
        provider: .email
      )
      return AuthSession(token: token, user: user)
    } catch {
      throw mapFirebaseError(error)
    }
  }
  
  public func socialLogin(provider: AuthProvider, idToken: String, accessToken: String?) async throws -> AuthSession {
    let credential: AuthCredential
    if provider == .google, let accessToken = accessToken {
      credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    } else if provider == .apple {
      // For Apple, we receive the rawNonce in the idToken parameter, and the actual idToken in the accessToken parameter.
      credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: accessToken ?? "", rawNonce: idToken)
    } else {
      throw AuthError.invalidCredentials
    }
    
    do {
      let result = try await Auth.auth().signIn(with: credential)
      let token = try await result.user.getIDToken()
      let user = User(
        id: result.user.uid,
        email: result.user.email,
        displayName: result.user.displayName,
        provider: provider
      )
      return AuthSession(token: token, user: user)
    } catch {
      throw mapFirebaseError(error)
    }
  }
  
  public func logout() async throws {
    do {
      try Auth.auth().signOut()
    } catch {
      throw AuthError.unknown
    }
  }
  
  private func mapFirebaseError(_ error: Error) -> AuthError {
    let nsError = error as NSError
    // FirebaseAuth Error domains and codes can be mapped here
    if nsError.code == AuthErrorCode.userNotFound.rawValue {
      return .userNotFound
    } else if nsError.code == AuthErrorCode.wrongPassword.rawValue {
      return .invalidCredentials
    } else if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
      return .emailAlreadyInUse
    } else if nsError.code == AuthErrorCode.networkError.rawValue {
      return .networkError
    }
    
    // Pass the descriptive error from Firebase back to the user
    return .custom(error.localizedDescription)
  }
}
