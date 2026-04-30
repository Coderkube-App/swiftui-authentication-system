//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

public enum GoogleSignInError: Error {
    case noRootViewController
    case authFailed(Error)
    case cancelled
}

@MainActor
public class GoogleSignInHelper {
    public static let shared = GoogleSignInHelper()
    
    private init() {}
    
    public func signIn() async throws -> (idToken: String, accessToken: String) {
        guard let rootViewController = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow }).first?.rootViewController else {
            throw GoogleSignInError.noRootViewController
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw GoogleSignInError.authFailed(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing ID token"]))
            }
            
            return (idToken: idToken, accessToken: result.user.accessToken.tokenString)
        } catch let error {
            // Google Sign In throws an error if user cancels. We can catch it or pass it.
            throw GoogleSignInError.authFailed(error)
        }
    }
}
