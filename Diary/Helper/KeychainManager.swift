//
//  KeychainManager.swift
//  Diary
//
//  Created by Immanuel on 02/05/24.
//

import Foundation

// keychain location: ~/Library/Developer/CoreSimulator/Devices/
// simulatorUUID/data/Library/Keychains

enum KeychainPasswordError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

struct KeychainManager {
    
    static func savePasswordToKeychain(username: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("keychain error - ", status)
        }
    }
    
    static func checkUserPasswordMatchingInKeychain(username: String, password: String) -> Bool {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            print("keychain error - ", status)
            return false
        }
        
        guard let existingItem = item as? [String : Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let keychainPassword = String(data: passwordData, encoding: String.Encoding.utf8),
              keychainPassword == password
        else {
            return false
        }
        
        return true
    }
    
}
