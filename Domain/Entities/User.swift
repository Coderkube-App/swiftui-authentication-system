//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

/// Core business entity representing a User.
public struct User: Identifiable, Equatable {
  public let id: String
  public let email: String?
  public let displayName: String?
  public let provider: AuthProvider
  
  public init(id: String, email: String?, displayName: String?, provider: AuthProvider) {
    self.id = id
    self.email = email
    self.displayName = displayName
    self.provider = provider
  }
}

public enum AuthProvider: String {
  case email
  case google
  case apple
  case custom
}
