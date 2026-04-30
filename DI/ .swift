//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

/// Centralized Dependency Injection Container.
/// Manages the creation of dependencies for each layer.
@MainActor
public class DIContainer: ObservableObject {
  public static let shared = DIContainer()
  
  // Core layer
  public let keychainStorage: KeychainStorageProtocol
  public let sessionManager: SessionManagerProtocol
  
  // Data layer
  public let authRemoteDataSource: AuthRemoteDataSourceProtocol
  public let authRepository: AuthRepositoryProtocol
  
  // Domain layer (UseCases)
  public let loginUseCase: LoginUseCase
  public let signupUseCase: SignupUseCase
  public let socialLoginUseCase: SocialLoginUseCase
  public let logoutUseCase: LogoutUseCase
  
  private init() {
    // Initialize Core
    self.keychainStorage = KeychainStorage()
    self.sessionManager = SessionManager(keychain: self.keychainStorage)
    
    // Initialize Data
    self.authRemoteDataSource = FirebaseAuthDataSource()
    self.authRepository = AuthRepositoryImpl(remoteDataSource: self.authRemoteDataSource, sessionManager: self.sessionManager)
    
    // Initialize Domain (UseCases)
    self.loginUseCase = LoginUseCase(repository: self.authRepository)
    self.signupUseCase = SignupUseCase(repository: self.authRepository)
    self.socialLoginUseCase = SocialLoginUseCase(repository: self.authRepository)
    self.logoutUseCase = LogoutUseCase(repository: self.authRepository)
  }
  
  // MARK: - ViewModels Providers
  
  public func makeLoginViewModel() -> LoginViewModel {
    return LoginViewModel(loginUseCase: loginUseCase, socialLoginUseCase: socialLoginUseCase)
  }
  
  public func makeSignupViewModel() -> SignupViewModel {
    return SignupViewModel(signupUseCase: signupUseCase)
  }
  
  public func makeHomeViewModel() -> HomeViewModel {
    return HomeViewModel(logoutUseCase: logoutUseCase, authRepository: authRepository)
  }
}
