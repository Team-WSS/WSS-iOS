//
//  KeychainHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/24/25.
//

import Foundation

protocol KeychainBasic {
    func create(data: Data?, forKey account: String) throws
    func read(forKey account: String) throws -> Data?
    func update(data: Data?, forKey account: String) throws
    func delete(forKey account: String) throws
}

final class KeychainHelper: KeychainBasic {
    static let shared = KeychainHelper()
    private init() {}
    
    private var service: String {
        guard let service = Bundle.main.bundleIdentifier else {
            fatalError("Bundle Identifier is missing. Keychain cannot be configured.")
        }
        return service
    }
    
    func create(data: Data?, forKey account: String) throws {
        guard let data else {
            throw KeychainError.noData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func read(forKey account: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            return item as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func update(data: Data?, forKey account: String) throws {
        guard let data else {
            throw KeychainError.noData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func delete(forKey account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}

// MARK: - KeychainHelper String ver

extension KeychainHelper {
    func create(value: String, forKey account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataEncodingFailed
        }
        try create(data: data, forKey: account)
    }
    
    func update(value: String, forKey account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataEncodingFailed
        }
        try update(data: data, forKey: account)
    }
}

// MARK: - Error

enum KeychainError: Error, CustomStringConvertible {
    case noData
    case dataEncodingFailed
    case unhandledError(status: OSStatus)

    var description: String {
        prefix + content
    }
    
    var content: String {
        switch self {
        case .noData:
            return "No data found"
        case .dataEncodingFailed:
            return "Failed to encode data"
        case .unhandledError(status: let status):
            return "Unhandled error: \(status)"
        }
    }
    
    var prefix: String {
        "KEYCHAIN ERROR: "
    }
}
