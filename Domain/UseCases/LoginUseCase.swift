//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

public struct LoginUseCase {
  private let repository: AuthRepositoryProtocol
  
  public init(repository: AuthRepositoryProtocol) {
    self.repository = repository
  }
  
  public func execute(email: String, password: String) async throws -> AuthSession {
    return try await repository.login(email: email, password: password)
  }
}
