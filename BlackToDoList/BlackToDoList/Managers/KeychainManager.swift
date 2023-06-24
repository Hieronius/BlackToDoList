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
    
    static var serviceId = "BlackToDoList"
    static var currentUser = "User"
    
    // MARK: NEED DOCUMENTATION
    // Get data and encrypt it.
    // Function can throw an error.
    // Can't rename function 18.06.23 due to an error. Let's try again later.
    static func saveData(
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
    static func getData(
        service: String,
        account: String
        // We wan't extract password, so we don't need this input parameter.
        // This data should be extracted with Data type.
    ) throws -> Data? {
        // Service, account, password, class, data.
        // Seems like it's not a dictionary of data, but a one object as unmutable data.
        // Like one user, one password, one page and so one.
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
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
        // If item is already exists throw an error.
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        // If our status is ok, let's do some job.
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
       
        // Print if there is an Error
        print("Read status: \(status)")
        return result as? Data
    }
    
    // MARK: NEED DOCUMENTATION WITH MARKDAWN.
    static func deleteData(
        service: String,
        account: String
        // We wan't extract password to delete it, so we don't need this input parameter.
    ) throws {
        // Abstraction of the data storage.
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            // Our service.
            kSecAttrService: service,
            // Our account.
            kSecAttrAccount: account]
        
        
        
        let status = SecItemDelete(query as CFDictionary)
        // Print if there is an Error
        print("Read status: \(status)")
        guard status == errSecSuccess else {
            print(KeychainError.unknown(status).localizedDescription)
            print("Delete data Error")
            throw KeychainError.unknown(status)
        }
    }
    
    
    // MARK: MAKE BETTER EXPLANATION FOR THIS FUNCTION
    /// Get's all stored data as dictionary with the type of given `secClass`.
    ///
    /// ```
    /// getAllKeyChainItemsOfClass(_ secClass: kSecClassGenericPassword as String) // ["User6": "[7, 8, 9, 6]"
    /// ```
    ///
    /// > Warning: possible to find data only with kSecClassGenericPassword
    /// > all other data such as "kSecAttrService as String" - User service or
    /// > "kSecAttrAccount as String" - User account will return nil
    ///
    /// - Parameters:
    ///     - secClass: Class of data to find
    ///
    /// - Returns: All stored data as dictionary of the given type  `secClass`.
    static func getAllKeyChainItemsOfClass(_ secClass: String) -> [String: String] {
        // Storage of all possible data from Keychain.
        let query: [String: Any] = [
            kSecClass as String: secClass,
            kSecReturnData as String: kCFBooleanTrue,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecReturnRef as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String: String]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            
            for item in array! {
                if let key = item[kSecAttrAccount as String] as? String,
                   let value = item[kSecValueData as String] as? Data {
                    values[key] = String(data: value, encoding: .utf8)
                }
            }
        }
        return values
    }
    
    /// Delete all stored data as dictionary with the type of given `secClass`.
    ///
    /// ```
    /// getAllKeyChainItemsOfClass(_ secClass: kSecClassGenericPassword as String) // [:]"
    /// ```
    ///
    /// > Warning: possible to find data only with kSecClassGenericPassword
    /// > all other data such as "kSecAttrService as String" - User service or
    /// > "kSecAttrAccount as String" - User account will return nil
    ///
    /// - Parameters:
    ///     - secClass: Class of data to find and delete
    ///
    /// - Returns: Delete all stored data as dictionary of the given type  `secClass`.
    static func getAllKeyChainItemsOfClassAndDelete(_ secClass: String) -> [String: String] {
        // Storage of all possible data from Keychain.
        let query: [String: Any] = [
            kSecClass as String: secClass,
            kSecReturnData as String: kCFBooleanTrue,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecReturnRef as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String: String]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            
            for item in array! {
                SecItemDelete(item as CFDictionary)
                print("\(item) has been deleted")
            }
        }
        return values
    }
}
