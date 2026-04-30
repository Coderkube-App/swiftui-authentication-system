//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

public struct LoginView: View {
  @StateObject private var viewModel: LoginViewModel
  
  // We can use a closure to handle navigation to Signup,
  // or let a Coordinator handle it via EnvironmentObject or similar.
  var onNavigateToSignup: () -> Void
  
  public init(viewModel: LoginViewModel, onNavigateToSignup: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.onNavigateToSignup = onNavigateToSignup
  }
  
  public var body: some View {
    ZStack {
      // Background Gradient
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      ScrollView {
        VStack(spacing: 25) {
          VStack(spacing: 10) {
            Image(systemName: "lock.shield.fill")
              .font(.system(size: 60))
              .foregroundColor(.blue)
              .padding(.bottom, 10)
            
            Text("Welcome Back")
              .font(.largeTitle)
              .fontWeight(.bold)
            
            Text("Sign in to continue")
              .foregroundColor(.secondary)
          }
          .padding(.top, 60)
          .padding(.bottom, 30)
          
          VStack(spacing: 15) {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope.fill")
              .keyboardType(.emailAddress)
            
            CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true, iconName: "lock.fill")
          }
          
          if let error = viewModel.errorMessage {
            Text(error)
              .foregroundColor(.red)
              .font(.footnote)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
              .transition(.opacity)
          }
          
          PrimaryButton(title: "Log In", isLoading: viewModel.isLoading) {
            viewModel.login()
          }
          .padding(.top, 10)
          
          HStack {
            Text("Don't have an account?")
              .foregroundColor(.secondary)
            Button("Sign Up") {
              onNavigateToSignup()
            }
            .fontWeight(.semibold)
            .foregroundColor(.blue)
          }
          .font(.subheadline)
          
          VStack(spacing: 20) {
            HStack {
              Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
              Text("OR").font(.caption).foregroundColor(.gray).padding(.horizontal)
              Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            }
            .padding(.horizontal, 30)
            
            HStack(spacing: 25) {
              SocialIconButton(iconName: "g.circle.fill", action: {
                viewModel.loginWithGoogle()
              })
              
              SocialIconButton(iconName: "applelogo", backgroundColor: .black, iconColor: .white, action: {
                viewModel.loginWithApple()
              })
            }
          }
          .padding(.top, 20)
          
          Spacer()
        }
        .padding()
      }
    }
    .toast(item: $viewModel.toast)
  }
}
