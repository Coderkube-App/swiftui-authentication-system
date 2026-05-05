//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation
import Combine

/// Protocol for managing user session state securely.
public protocol SessionManagerProtocol {
  var isLoggedInPublisher: AnyPublisher<Bool, Never> { get }
  var currentToken: String? { get }
  
  func saveSession(token: String)
  func clearSession()
}

/// Concrete implementation of SessionManagerProtocol.
public class SessionManager: SessionManagerProtocol {
  private let keychain: KeychainStorageProtocol
  private let tokenKey = "com.ck.events.app.sessionToken"
  
  private let _isLoggedIn = CurrentValueSubject<Bool, Never>(false)
  
  public var isLoggedInPublisher: AnyPublisher<Bool, Never> {
    return _isLoggedIn.eraseToAnyPublisher()
  }
  
  public var currentToken: String? {
    if let data = keychain.load(key: tokenKey) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
  
  public init(keychain: KeychainStorageProtocol) {
    self.keychain = keychain
    checkExistingSession()
  }
  
  private func checkExistingSession() {
    _isLoggedIn.send(currentToken != nil)
  }
  
  public func saveSession(token: String) {
    guard let data = token.data(using: .utf8) else { return }
    _ = keychain.save(key: tokenKey, data: data)
    _isLoggedIn.send(true)
  }
  
  public func clearSession() {
    _ = keychain.delete(key: tokenKey)
    _isLoggedIn.send(false)
  }
}
