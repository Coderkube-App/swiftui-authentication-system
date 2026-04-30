//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

public struct SignupView: View {
  @StateObject private var viewModel: SignupViewModel
  var onNavigateBackToLogin: () -> Void
  
  public init(viewModel: SignupViewModel, onNavigateBackToLogin: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.onNavigateBackToLogin = onNavigateBackToLogin
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
            Image(systemName: "person.badge.plus")
              .font(.system(size: 60))
              .foregroundColor(.blue)
              .padding(.bottom, 10)
            
            Text("Create Account")
              .font(.largeTitle)
              .fontWeight(.bold)
            
            Text("Sign up to get started")
              .foregroundColor(.secondary)
          }
          .padding(.top, 60)
          .padding(.bottom, 30)
          
          VStack(spacing: 15) {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope.fill")
              .keyboardType(.emailAddress)
            
            CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true, iconName: "lock.fill")
            
            CustomTextField(placeholder: "Confirm Password", text: $viewModel.confirmPassword, isSecure: true, iconName: "lock.shield.fill")
          }
          
          if let error = viewModel.errorMessage {
            Text(error)
              .foregroundColor(.red)
              .font(.footnote)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
              .transition(.opacity)
          }
          
          PrimaryButton(title: "Sign Up", isLoading: viewModel.isLoading) {
            viewModel.signup()
          }
          .padding(.top, 10)
          
          HStack {
            Text("Already have an account?")
              .foregroundColor(.secondary)
            Button("Log In") {
              onNavigateBackToLogin()
            }
            .fontWeight(.semibold)
            .foregroundColor(.blue)
          }
          .font(.subheadline)
          
          Spacer()
        }
        .padding()
      }
    }
    .toast(item: $viewModel.toast)
    .onChange(of: viewModel.isSignupSuccessful) { success in
      if success {
        onNavigateBackToLogin()
      }
    }
  }
}
