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
        // Error of all purposes type.
        case unknown(OSStatus)
    }
    
    // Get data and encrypt it.
    // Function can throw an error.
    static func save(
        // a few input parameters to identify what we wan't to save and where.
        service: String,
        account: String,
        password: Data
    ) throws {
        // Service, account, password, class, data.
        // Seems like it's not a dictionary of data, but a one object as unmutable data.
        // Like one user, one password, one page and so one.
        let query: [CFString: Any] = [
            // Seems like exactly this object mean we wan't to save only password to keychain.
            kSecClass: kSecClassGenericPassword,
            // Our service.
            kSecAttrService: service,
            // Our account.
            kSecAttrAccount: account,
            // Out password.
            kSecValueData: password
        ]
        // This chunk of code should add to our Dictionary a checkout of data for being "nil".
        // Our current status.
        let status = SecItemAdd(query as CFDictionary, nil)
        // If item is already exists throw an error.
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        // If our status is ok, let's do some job.
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        // Save data.
        print("saved")
    }
    
    // Find data and give it.
    static func get(
        service: String,
        account: String
        // We wan't extract password, so we don't need this input parameter.
        // This data should be extracted with Data type.
    ) -> Data? {
        // Service, account, password, class, data.
        // Seems like it's not a dictionary of data, but a one object as unmutable data.
        // Like one user, one password, one page and so one.
        let query: [CFString: Any] = [
            kSecClass:kSecClassGenericPassword,
            // Our service.
            kSecAttrService: service,
            // Our account.
            kSecAttrAccount: account,
            // Out password data type for exctaction.
            // Seems like mean is there a data for return action.
            kSecReturnData: kCFBooleanTrue as Any,
            // How many items to match we wan't with requested data.
            // So, the answer is one single item.
            kSecMatchLimit: kSecMatchLimitOne
        ]
        // What kind of result we expecting from exctraction.
        var result: AnyObject?
        // return one or more items (depend of parameter above) from Keychain.
        let status = SecItemCopyMatching(
            query as CFDictionary,
            // i don't know why this parameter should be "inout"
            &result
        )
        // Print if there is an Error
        print("Read status: \(status)")
        return result as? Data
    }
}

// MARK: Example of implementation
//private func getPassword() {
//    guard let data = KeychainManager.get(
//        service: "BlackToDoList",
//        account: "User"
//    ) else {
//        print("Failed to read password")
//        return
//    }
//    let password = String(decoding: data, as: UTF8.self)
//    print("Read password: \(password)")
//}
//
//private func save() {
//    do {
//        try KeychainManager.save(
//            service: "BlackToDoList",
//            account: "User",
//            // encode password with .utf8 encrypt code
//            password: "some password".data(using: .utf8) ?? Data())
//    } catch {
//        print(error)
//    }
//}
