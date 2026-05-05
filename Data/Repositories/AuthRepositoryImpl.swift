//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

public class AuthRepositoryImpl: AuthRepositoryProtocol {
  private let remoteDataSource: AuthRemoteDataSourceProtocol
  private let sessionManager: SessionManagerProtocol
  
  // We keep a local reference to the current user in memory,
  // or we could persist it locally. For simplicity, we keep the session active.
  private var currentAuthSession: AuthSession?
  
  public init(remoteDataSource: AuthRemoteDataSourceProtocol, sessionManager: SessionManagerProtocol) {
    self.remoteDataSource = remoteDataSource
    self.sessionManager = sessionManager
  }
  
  public func login(email: String, password: String) async throws -> AuthSession {
    let session = try await remoteDataSource.login(email: email, password: password)
    sessionManager.saveSession(token: session.token)
    currentAuthSession = session
    return session
  }
  
  public func signup(email: String, password: String) async throws -> AuthSession {
    let session = try await remoteDataSource.signup(email: email, password: password)
    // We don't save the session here because the user wants to be pushed to login screen after signup
    // sessionManager.saveSession(token: session.token)
    currentAuthSession = session
    return session
  }
  
  public func socialLogin(provider: AuthProvider, idToken: String, accessToken: String?) async throws -> AuthSession {
    let session = try await remoteDataSource.socialLogin(provider: provider, idToken: idToken, accessToken: accessToken)
    sessionManager.saveSession(token: session.token)
    currentAuthSession = session
    return session
  }
  
  public func logout() async throws {
    try await remoteDataSource.logout()
    sessionManager.clearSession()
    currentAuthSession = nil
  }
  
  public func getCurrentSession() -> AuthSession? {
    // In a real app, if currentAuthSession is nil but sessionManager has a token,
    // we might want to fetch the user profile from the backend.
    // For this boilerplate, we'll return the active memory session.
    return currentAuthSession
  }
}
