//
//  Config.swift
//  Alamofire
//
//  Created by jenkins on 2020/9/24.
//

import Foundation

public enum NetworkParameter {
    
    case mainNet
    case testNet(chainId: String)
    
    public var chainId: String {
        switch self {
        case .testNet(let id):
            return id
        default:
            return "201018"
        }
    }
    
    public var unit: String {
        return "ATP"
    }
    
    public var addrPrefix: String {
        switch self {
        case .testNet( _):
            return "atx"
        default:
            return "atp"
        }
    }
    
    public var coinCode: Int {
        return 206
    }

}
