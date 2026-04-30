//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit

public enum AppleSignInError: Error, LocalizedError {
    case noRootViewController
    case authFailed(Error)
    case cancelled
    case invalidCredential
    
    public var errorDescription: String? {
        switch self {
        case .noRootViewController: return "Could not find root view controller."
        case .authFailed(let error): return error.localizedDescription
        case .cancelled: return "Apple Sign-In was cancelled."
        case .invalidCredential: return "Invalid Apple ID credential."
        }
    }
}

@MainActor
public class AppleSignInHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public static let shared = AppleSignInHelper()
    
    private override init() { super.init() }
    
    private var currentNonce: String?
    private var continuation: CheckedContinuation<(idToken: String, rawNonce: String), Error>?
    
    public func signIn() async throws -> (idToken: String, rawNonce: String) {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let nonce = randomNonceString()
            self.currentNonce = nonce
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                continuation?.resume(throwing: AppleSignInError.invalidCredential)
                continuation = nil
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                continuation?.resume(throwing: AppleSignInError.invalidCredential)
                continuation = nil
                return
            }
            
            continuation?.resume(returning: (idToken: idTokenString, rawNonce: nonce))
            continuation = nil
        } else {
            continuation?.resume(throwing: AppleSignInError.invalidCredential)
            continuation = nil
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: AppleSignInError.authFailed(error))
        continuation = nil
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow }).first ?? ASPresentationAnchor()
    }
    
    // MARK: - Crypto Helpers
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
