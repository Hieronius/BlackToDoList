//
//  KeyChainManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 12.06.2023.
//

import UIKit

final class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
        case invalidData
    }
    
    // Should think where to place it in correct way.
    static var serviceId = "BlackToDoList"
    static var currentUser = "User"
    
    /**
     This static function is used to save data to the Keychain, which securely stores sensitive information like passwords. It takes three input parameters: `service` (a string representing the service or application for which the data is being saved), `account` (a string representing the account or user associated with the data), and `password` (an array of integers representing the password to be saved).

     - Parameters:
        - service: a string representing the service or application for which the data is being saved.
        - account: a string representing the account or user associated with the data.
        - password: an array of integers representing the password to be saved.
     
     - Throws: The function throws a `KeychainError.duplicateEntry` error if there is already an existing keychain item with the same `service` and `account`. It throws a `KeychainError.unknown` error if the save operation is unsuccessful.

     **The function performs the following steps:**

     1. It archives the `password` array into an `NSData` object using `NSKeyedArchiver`.
     2. Constructs a query dictionary using Core Foundation types (`CFString` and `Any`) to specify the details of what data to save.
     3. Sets the `kSecClass` key to `kSecClassGenericPassword`, indicating that only the password will be saved to the Keychain.
     4. Sets the `kSecAttrService` key to the provided `service` value.
     5. Sets the `kSecAttrAccount` key to the provided `account` value.
     6. Sets the `kSecValueData` key to the archived `password` data.
     7. Attempts to add the item to the Keychain using `SecItemAdd`.
     8. If the item already exists (status is `errSecDuplicateItem`), it throws a `KeychainError.duplicateEntry`.
     9. If the status is not successful (status is not `errSecSuccess`), it throws a `KeychainError.unknown` with the `status` value as the associated error.

     - Important: Please note that the types used in this code snippet (`CFString`, `SecItemAdd`, etc.) are part of Apple's Security Framework.
     */
    static func saveData(service: String, account: String, password: [Int]) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: password,
                                                    requiringSecureCoding: true)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    /**
     This function retrieves the data associated with a given service and account from the keychain and returns it as an array of integers.
     
     - Parameter service: A string representing the service associated with the data to retrieve.
     - Parameter account: A string representing the account associated with the data to retrieve.
     
     - Throws: A `KeychainError` if the data retrieval is unsuccessful. Possible errors include `duplicateEntry` if there is a duplicate keychain item, `unknown` if there is an unknown error, and `invalidData` if the retrieved data is invalid.
     
     - Returns: An optional array of integers representing the retrieved data. If the data retrieval is unsuccessful or the retrieved data is not an array of integers, `nil` is returned.
     */
    static func getData(service: String, account: String) throws -> [Int]? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.invalidData
        }
        
        let passcode = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Int]
        return passcode
    }
    
    /**
    The `deleteData` function is a static function that deletes data from the keychain.
     
     - Parameters:
       - service: A string representing the service associated with the data to be deleted.
       - account: A string representing the account associated with the data to be deleted
     
     - Throws: The function throws a `KeychainError.unknown` error if the deletion is unsuccessful.
     
     - Note: The function first creates a query dictionary with the `kSecClass`, `kSecAttrService`, and `kSecAttrAccount` keys and their respective values. This query is used to identify the data to be deleted from the keychain.
     
     The function then attempts to delete the identified data using the `SecItemDelete` function. If the deletion is unsuccessful, the function throws a `KeychainError.unknown` error.

     If the deletion is successful, the function prints the status of the deletion using `print("Read status: \(status)")`.
    */
    static func deleteData(service: String, account: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account]
        
        let status = SecItemDelete(query as CFDictionary)
        print("Read status: \(status)")
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    /**
     Get's all stored data as dictionary with the type of given `secClass`.
     
     - Warning: possible to find data only with kSecClassGenericPassword
     all other data such as "kSecAttrService as String" - User service or
     "kSecAttrAccount as String" - User account will return nil
     
     - Parameters:
       - secClass: Class of data to find
     
     - Returns: All stored data as dictionary of the given type  `secClass`.
     */
    static func getAllKeyChainItemsOfClass(_ secClass: String) -> [String: String] {
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
}


