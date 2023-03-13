//
//  KeychainAuthWorker.swift
//  TruliooAssignment
//
//  Created by Roni Leshes on 12/03/2023.
//

import Foundation

enum KeychainAuthError: Error {
    case usernameNotFound(username: String)
    case passwordIsIncorrect
    case usernameAlreadyExists(username: String)
    case unhandledError(errorMessage: String)
}

extension KeychainAuthError: LocalizedError{
    public var errorDescription: String?{
        switch self{
        case .usernameAlreadyExists(let username):
            return "Username '\(username)' already exists!"
        case .passwordIsIncorrect:
            return "Password is incorrect!"
        case .usernameNotFound(let username):
            return "Could not find user with username: '\(username)'"
        case .unhandledError(let errorMessage):
            return errorMessage
        }
    }
}

class KeychainAuthWorker: AuthWorker{
    private func nsErrorFromOSStatus(_ status: OSStatus) -> NSError{
        return NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey: SecCopyErrorMessageString(status, nil) ?? "Undefined error"])
    }
    
    func login(username: String, password: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecAttrAccount as String: username,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainAuthError.usernameNotFound(username: username) }
        guard status == errSecSuccess else {
            let error = nsErrorFromOSStatus(status)
            throw KeychainAuthError.unhandledError(errorMessage: error.localizedDescription)
        }
        
        guard let existingItem = item as? [String : Any],
            let savedPasswordData = existingItem[kSecValueData as String] as? Data,
            let savedPassword = String(data: savedPasswordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainAuthError.unhandledError(errorMessage: "Unexpected Password Data")
        }
        
        if savedPassword != password{
            throw KeychainAuthError.passwordIsIncorrect
        }
    }
    
    func register(username: String, password: String) throws {
        let passwordData = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: username,
                                    kSecValueData as String: passwordData]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            let error = nsErrorFromOSStatus(status)
            print(error)
            if status == errSecDuplicateItem{
                throw KeychainAuthError.usernameAlreadyExists(username: username)
            }else{
                throw KeychainAuthError.unhandledError(errorMessage: error.localizedDescription)
            }
        }
    }
}
