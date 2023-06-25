//
//  NWInterface+Extension.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 25.06.2023.
//

import Foundation
import UIKit
import Network

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
            .other,
            .wifi,
            .cellular,
            .loopback,
            .wiredEthernet
    ]
}
