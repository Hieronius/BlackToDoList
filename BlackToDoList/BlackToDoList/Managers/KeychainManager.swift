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
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    // Get data and encrypt it.
    static func save() {
        // service, account, password, class, data.
    }
    
    // Find data and give it.
    static func get() {
        // service, account, class, data, matchlimit.
    }
}
