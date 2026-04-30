//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation
import Security

/// Protocol defining secure storage operations.
public protocol KeychainStorageProtocol {
  func save(key: String, data: Data) -> OSStatus
  func load(key: String) -> Data?
  func delete(key: String) -> OSStatus
}

/// Concrete implementation of KeychainStorageProtocol using Apple's Security framework.
public class KeychainStorage: KeychainStorageProtocol {
  
  public init() {}
  
  public func save(key: String, data: Data) -> OSStatus {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: data
    ] as [String: Any]
    
    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }
  
  public func load(key: String) -> Data? {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue!,
      kSecMatchLimit as String: kSecMatchLimitOne
    ] as [String: Any]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == errSecSuccess {
      return dataTypeRef as? Data
    }
    return nil
  }
  
  public func delete(key: String) -> OSStatus {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ] as [String: Any]
    
    return SecItemDelete(query as CFDictionary)
  }
}
