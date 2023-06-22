//
//  MarkDown.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 22.06.2023.
//

import Foundation

/// Produce a greeting string for the given `subject`.
    ///
    /// ```
    /// print(hello("world")) // "Hello, world!"
    /// ```
    ///
    /// > Warning: The returned greeting is not localized. To
    /// > produce a localized string, use ``localizedHello(_:)``
    /// > instead.
    ///
    /// - Parameters:
    ///     - subject: The subject to be welcomed.
    ///
    /// - Returns: A greeting for the given `subject`.
    func hello(_ subject: String) -> String {
        return "Hello, \(subject)!"
    }
