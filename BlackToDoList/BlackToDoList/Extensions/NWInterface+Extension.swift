import Foundation
import UIKit
import Network


extension NWInterface.InterfaceType: CaseIterable {
    /// An array of all possible cases of the `NWInterface.InterfaceType` enumeration, including `.other`, `.wifi`, `.cellular`, `.loopback`, and `.wiredEthernet`. This property is required by the `CaseIterable` protocol.
    public static var allCases: [NWInterface.InterfaceType] = [
            .other,
            .wifi,
            .cellular,
            .loopback,
            .wiredEthernet
    ]
}
