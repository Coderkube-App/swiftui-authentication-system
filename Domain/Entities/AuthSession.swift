//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

/// Represents an active authentication session.
public struct AuthSession: Equatable {
  public let token: String
  public let user: User
  
  public init(token: String, user: User) {
    self.token = token
    self.user = user
  }
}
