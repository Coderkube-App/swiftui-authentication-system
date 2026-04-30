//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation

public struct SocialLoginUseCase {
  private let repository: AuthRepositoryProtocol
  
  public init(repository: AuthRepositoryProtocol) {
    self.repository = repository
  }
  
  public func execute(provider: AuthProvider, idToken: String, accessToken: String?) async throws -> AuthSession {
    return try await repository.socialLogin(provider: provider, idToken: idToken, accessToken: accessToken)
  }
}
