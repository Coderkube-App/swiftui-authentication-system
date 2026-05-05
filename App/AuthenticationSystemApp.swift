//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Initialize Firebase if plist exists
    if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
      FirebaseApp.configure()
    } else {
      print("⚠️ WARNING: GoogleService-Info.plist is missing. Firebase Authentication will not work.")
    }
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      // Handle Google Sign-In redirect
      return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct AuthenticationSystemApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var coordinator: AppCoordinator
  
  init() {
    let diContainer = DIContainer.shared
    _coordinator = StateObject(wrappedValue: AppCoordinator(diContainer: diContainer))
  }
  
  var body: some Scene {
    WindowGroup {
      RootCoordinatorView(coordinator: coordinator)
    }
  }
}

struct RootCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        coordinator.start()
    }
}
