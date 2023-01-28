//
//  NetworkReachability.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import Foundation
import SystemConfiguration


/// This class is use for check whether mobile device is connected to internet or not
class NetworkReachabilityManager {
    
    /// Call this type method to check internet connectivity
    ///
    ///
    /// - Returns: if internet is connected to device, function will return true otherwise false.
    ///
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
