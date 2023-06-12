//
//  KeyChainManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 12.06.2023.
//

import UIKit

final class KeychainManager {
    
    // Enum for handling errors of the Keychain.
    enum KeychainError: Error {
        // The data already exists.
        case duplicateEntry
        // Can't identify data request.
        case unknown(OSStatus)
    }
    
    // Get data and encrypt it.
    // Function can throw an error.
    static func save() throws {
        // service, account, password, class, data.
        let query: [String: AnyObject] = [
            kSecClass as String: "",
            kSecAttrService
        ]
    }
    
    // Find data and give it.
    static func get() {
        // service, account, class, data, matchlimit.
    }
}
