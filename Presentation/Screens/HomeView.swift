//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

public struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  
  public init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 30) {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundColor(.blue)
        .padding(.top, 50)
      
      VStack(spacing: 10) {
        Text("Welcome!")
          .font(.largeTitle)
          .fontWeight(.bold)
        
        Text(viewModel.userEmail)
          .font(.title3)
          .foregroundColor(.gray)
        
        Text("Logged in via: \(viewModel.userProvider)")
          .font(.footnote)
          .padding(.top, 5)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      PrimaryButton(title: "Log Out") {
        viewModel.showingLogoutAlert = true
      }
      .padding(.bottom, 40)
    }
    .padding()
    .alert("Log Out", isPresented: $viewModel.showingLogoutAlert) {
        Button("Log Out", role: .destructive) {
            viewModel.logout()
        }
        Button("Cancel", role: .cancel) {}
    } message: {
        Text("Are you sure you want to log out?")
    }
  }
}
