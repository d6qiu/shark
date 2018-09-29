//
//  InternetConnection.swift
//  
//
//  Created by wenlong qiu on 9/29/18.
//

import Foundation
import Alamofire
class InternetConnection {
    class func connectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
