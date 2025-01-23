import Foundation

// MARK: - Protocols

protocol KeychainBasic {
    func create(account: String, data: Data?) throws
    func read(account: String) throws -> Data?
    func update(account: String, data: Data?) throws
    func delete(account: String) throws
}

// MARK: - KeychainHelper

final class KeychainHelper: KeychainBasic {
    static let shared = KeychainHelper()
    private init() {}
    
    private var service: String {
        guard let service = Bundle.main.bundleIdentifier else {
            fatalError("Bundle Identifier is missing. Keychain cannot be configured.")
        }
        return service
    }
    
    // 1. Create (Data)
    func create(account: String, data: Data?) throws {
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
    
    // 2. Read (Data)
    func read(account: String) throws -> Data? {
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
    
    // 3. Update (Data)
    func update(account: String, data: Data?) throws {
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
    
    // 4. Delete
    func delete(account: String) throws {
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
    func create(account: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataEncodingFailed
        }
        try create(account: account, data: data)
    }
    
    func update(account: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataEncodingFailed
        }
        try update(account: account, data: data)
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
